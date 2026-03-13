import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PinchToZoomImage extends StatefulWidget {
  final String imageUrl;
  const PinchToZoomImage({super.key, required this.imageUrl});

  @override
  State<PinchToZoomImage> createState() => _PinchToZoomImageState();
}

class _PinchToZoomImageState extends State<PinchToZoomImage> with SingleTickerProviderStateMixin {
  late TransformationController _controller;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() => _controller.value = _animation!.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _resetAnimation() {
    _animation = Matrix4Tween(
      begin: _controller.value,
      end: Matrix4.identity(),
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1, // Instagram square 1:1 post
      child: InteractiveViewer(
        transformationController: _controller,
        panEnabled: false,
        clipBehavior: Clip.none, // Allows scaling over UI
        onInteractionEnd: (_) => _resetAnimation(),
        child: CachedNetworkImage(
          imageUrl: widget.imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(color: Colors.grey[900]),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}