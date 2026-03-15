// lib/presentation/widgets/pinch_to_zoom_image.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Global notifier that halts all feed scrolling when two fingers touch!
final ValueNotifier<bool> globalPinchNotifier = ValueNotifier<bool>(false);

class PinchToZoomImage extends StatefulWidget {
  final String imageUrl;

  const PinchToZoomImage({super.key, required this.imageUrl});

  @override
  State<PinchToZoomImage> createState() => _PinchToZoomImageState();
}

class _PinchToZoomImageState extends State<PinchToZoomImage> with SingleTickerProviderStateMixin {
  UniqueKey _cacheKey = UniqueKey();
  
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _offsetAnimation;

  double _scale = 1.0;
  Offset _offset = Offset.zero;
  Offset _initialFocalPoint = Offset.zero;
  Offset _sessionOffset = Offset.zero;

  OverlayEntry? _overlayEntry;
  final GlobalKey _imageKey = GlobalKey();
  
  int _pointers = 0;
  bool _isZooming = false;

  @override
  void initState() {
    super.initState();
    // 200ms with easeOutCubic mimics Instagram's snappy rubber-band physics
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _buildOverlay() {
    final renderBox = _imageKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        // Darken background up to 80% opacity based on zoom scale
        final double opacity = ((_scale - 1) / 1.5).clamp(0.0, 0.8);

        return Stack(
          children: [
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(opacity)),
            ),
            Positioned(
              left: position.dx,
              top: position.dy,
              width: size.width,
              height: size.height,
              child: Transform(
                transform: Matrix4.identity()
                  ..translate(_offset.dx, _offset.dy)
                  ..scale(_scale, _scale),
                alignment: FractionalOffset.center,
                child: _buildImage(),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Widget _buildImage() {
    return CachedNetworkImage(
      key: _cacheKey,
      imageUrl: widget.imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(color: Colors.grey[900]),
      errorWidget: (context, url, error) => GestureDetector(
        onTap: () {
          CachedNetworkImage.evictFromCache(widget.imageUrl).then((_) {
            if (mounted) setState(() => _cacheKey = UniqueKey());
          });
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.error_outline, color: Colors.white54, size: 30),
              SizedBox(height: 8),
              Text(
                "Couldn't load image.Tap to retry.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleScaleStart(ScaleStartDetails details) {
    if (_pointers < 2) return;
    
    _isZooming = true;
    _initialFocalPoint = details.focalPoint;
    _sessionOffset = Offset.zero;
    
    _buildOverlay();
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (!_isZooming) return;
    
    setState(() {
      _scale = details.scale.clamp(1.0, 4.0);
      
      // Calculate 1:1 panning offset tracking the user's fingers
      _sessionOffset = details.focalPoint - _initialFocalPoint;
      _offset = _sessionOffset;
    });
    
    _overlayEntry?.markNeedsBuild();
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    if (!_isZooming) return;
    
    globalPinchNotifier.value = false;
    
    // Animate everything back to the widget's physical bounds
    _scaleAnimation = Tween<double>(begin: _scale, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _offsetAnimation = Tween<Offset>(begin: _offset, end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    
    _animationController.addListener(() {
      _scale = _scaleAnimation.value;
      _offset = _offsetAnimation.value;
      _overlayEntry?.markNeedsBuild();
    });
    
    _animationController.forward(from: 0.0).then((_) {
      _removeOverlay();
      _isZooming = false;
      _scale = 1.0;
      _offset = Offset.zero;
      _animationController.removeListener(() {});
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        _pointers++;
        // PHYSICS KILL-SWITCH: Two fingers touch? Instantly stop all scrolling!
        if (_pointers >= 2) globalPinchNotifier.value = true;
      },
      onPointerUp: (_) {
        _pointers--;
        if (_pointers < 2 && !_isZooming) globalPinchNotifier.value = false;
      },
      onPointerCancel: (_) {
        _pointers--;
        if (_pointers < 2 && !_isZooming) globalPinchNotifier.value = false;
      },
      child: GestureDetector(
        key: _imageKey,
        onScaleStart: _handleScaleStart,
        onScaleUpdate: _handleScaleUpdate,
        onScaleEnd: _handleScaleEnd,
        // When zooming out over the screen, hide the native tile entirely!
        child: Opacity(
          opacity: _isZooming ? 0.0 : 1.0,
          child: _buildImage(),
        ),
      ),
    );
  }
}