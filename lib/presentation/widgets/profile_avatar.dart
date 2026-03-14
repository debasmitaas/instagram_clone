// lib/presentation/widgets/profile_avatar.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileAvatar extends StatelessWidget {
  final String userImageUrl;
  final double radius;
  final VoidCallback? onTap;
  final bool hasNotification;

  const ProfileAvatar({
    super.key,
    required this.userImageUrl,
    this.radius = 14,
    this.onTap,
    this.hasNotification = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: Colors.grey[800],
            backgroundImage: CachedNetworkImageProvider(userImageUrl),
          ),
          // Optional: Red dot indicator for notifications
          if (hasNotification)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }
}