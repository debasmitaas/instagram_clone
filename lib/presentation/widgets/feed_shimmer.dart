// lib/presentation/widgets/feed_shimmer.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FeedShimmer extends StatelessWidget {
  const FeedShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (_, index) {
        return Column(
          children: [
            if (index == 0) _buildStoriesShimmer(),
            _buildPostShimmer(context),
          ],
        );
      },
    );
  }

  Widget _buildStoriesShimmer() {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[900]!, width: 0.5),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        itemBuilder: (_, i) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Column(
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[900]!,
                  highlightColor: Colors.grey[800]!,
                  child: const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Shimmer.fromColors(
                  baseColor: Colors.grey[900]!,
                  highlightColor: Colors.grey[800]!,
                  child: Container(
                    height: 10,
                    width: 60,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPostShimmer(BuildContext context) {
    final imageHeight = MediaQuery.of(context).size.width * (5 / 4);
    return Shimmer.fromColors(
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[800]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.white,
            ),
            title: Container(
              height: 12,
              width: 120,
              color: Colors.white,
            ),
            trailing: const Icon(Icons.more_vert, color: Colors.white),
          ),
          Container(
            height: imageHeight,
            color: Colors.white,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Container(
              height: 24,
              width: 200,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}