// lib/presentation/widgets/pinch_to_zoom_image.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class PinchToZoomImage extends StatefulWidget {
  final String imageUrl;

  const PinchToZoomImage({super.key, required this.imageUrl});

  @override
  State<PinchToZoomImage> createState() => _PinchToZoomImageState();
}

class _PinchToZoomImageState extends State<PinchToZoomImage> {
  UniqueKey _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return PinchZoom(
      maxScale: 4.0,
      child: CachedNetworkImage(
        key: _key,
        imageUrl: widget.imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(color: Colors.grey[900]),
        errorWidget: (context, url, error) => GestureDetector(
          onTap: () {
            // Evict clear the failed image from cache and retry
            CachedNetworkImage.evictFromCache(widget.imageUrl).then((_) {
              if (mounted) {
                setState(() {
                  _key = UniqueKey(); // Rebuild widget to retry
                });
              }
            });
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.error_outline, color: Colors.white54, size: 30),
                SizedBox(height: 8),
                Text(
                  'ERROR LOADING IMAGES.\nTAP TO RETRY',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}