import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StoriesTray extends StatelessWidget {
  const StoriesTray({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[900]!, width: 0.5))),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (_, i) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(2.5),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle, 
                  gradient: LinearGradient(
                    colors: [Colors.yellow, Colors.orange, Colors.red, Colors.purple],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  )
                ),
                child: CircleAvatar(
                  radius: 30, backgroundColor: Colors.black,
                  child: CircleAvatar(
                    radius: 28,
                    backgroundImage: CachedNetworkImageProvider('https://picsum.photos/seed/story$i/100'),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(i == 0 ? 'Your story' : 'user_$i', style: const TextStyle(fontSize: 12, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}