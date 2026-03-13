// lib/presentation/widgets/pinch_to_zoom_image.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class PinchToZoomImage extends StatelessWidget {
  final String imageUrl;

  const PinchToZoomImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return PinchZoom(
      maxScale: 4.0,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(color: Colors.grey[900]),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}