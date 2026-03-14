// lib/presentation/widgets/double_tap_like_wrapper.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DoubleTapLikeWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onLike;

  const DoubleTapLikeWrapper({
    super.key,
    required this.child,
    required this.onLike,
  });

  @override
  State<DoubleTapLikeWrapper> createState() => _DoubleTapLikeWrapperState();
}

class _DoubleTapLikeWrapperState extends State<DoubleTapLikeWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _opacityAnim;
  late Animation<double> _slideAnim;

  // Clamped position — heart center, never goes off-edge
  double _heartLeft = 0;
  double _heartTop = 0;
  bool _isVisible = false;

  static const double _heartSize = 120.0;
  static const double _heartHalf = _heartSize / 2;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(
        // Fast elastic pop in: 0 → 1.25
        tween: Tween(begin: 0.0, end: 1.25)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        // Gentle settle: 1.25 → 1.1
        tween: Tween(begin: 1.25, end: 1.1)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        // Shrink out
        tween: Tween(begin: 1.1, end: 0.9)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
    ]).animate(_controller);

    _opacityAnim = TweenSequence<double>([
      // Fully visible for 65% of timeline
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 65),
      // Then fade out
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 35,
      ),
    ]).animate(_controller);

    // Float upward only during exit phase
    _slideAnim = Tween<double>(begin: 0.0, end: -24.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.65, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() => _isVisible = false);
        _controller.reset();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    // Get the actual rendered size of this widget so we can clamp
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final size = box.size;
    final tap = details.localPosition;

    // Clamp so the heart (120x120) never overflows the widget bounds.
    // We keep 8px padding from each edge.
    const edge = 8.0;
    _heartLeft = (tap.dx - _heartHalf)
        .clamp(edge, size.width - _heartSize - edge);
    _heartTop = (tap.dy - _heartHalf)
        .clamp(edge, size.height - _heartSize - edge);
  }

  void _handleDoubleTap() {
    widget.onLike();
    if (_controller.isAnimating) _controller.reset();
    setState(() => _isVisible = true);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onDoubleTap: _handleDoubleTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        fit: StackFit.passthrough,
        clipBehavior: Clip.hardEdge,
        children: [
          widget.child,

          if (_isVisible)
            Positioned(
              left: _heartLeft,
              top: _heartTop,
              width: _heartSize,
              height: _heartSize,
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(0, _slideAnim.value),
                    child: Opacity(
                      opacity: _opacityAnim.value,
                      child: Transform.scale(
                        scale: _scaleAnim.value,
                        // Scale from center of the Positioned box
                        alignment: Alignment.center,
                        child: child,
                      ),
                    ),
                  ),
                  // Rebuilt once — ShaderMask is expensive, keep it as const child
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors: [
                          Color(0xFFFFD700), // gold
                          Color(0xFFFF8C00), // orange
                          Color(0xFFFF2D55), // insta red-pink
                          Color(0xFFBF5AF2), // purple
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.srcIn,
                    child: const FaIcon(
                      FontAwesomeIcons.solidHeart,
                      size: _heartSize,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}