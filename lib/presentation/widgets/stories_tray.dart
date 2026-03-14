// lib/presentation/widgets/stories_tray.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StoriesTray extends StatelessWidget {
  const StoriesTray({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[900]!, width: 0.5),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (_, i) {
          final isYourStory = i == 0;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Column(
              children: [
                // Stack the + badge on top of the avatar for "Your story"
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Existing gradient ring + avatar — untouched
                    Container(
                      padding: const EdgeInsets.all(2.5),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Colors.yellow, Colors.orange, Colors.red, Colors.purple],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.black,
                        child: CircleAvatar(
                          radius: 33,
                          backgroundImage: CachedNetworkImageProvider(
                            'https://picsum.photos/seed/story$i/100',
                          ),
                        ),
                      ),
                    ),

                    // + badge — only on "Your story"
                    if (isYourStory)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.black,
                            size: 14,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 5),
                Text(
                  isYourStory ? 'Your story' : 'user_$i',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}