// lib/presentation/widgets/post_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../domain/models/post.dart';
import '../bloc/feed_bloc.dart';
import '../bloc/feed_event.dart';
import 'pinch_to_zoom_image.dart';

// Global notifier to lock all scroll views instantly
final ValueNotifier<bool> globalPinchNotifier = ValueNotifier<bool>(false);
int globalPointers = 0;

class PostWidget extends StatefulWidget {
  final Post post;
  const PostWidget({super.key, required this.post});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  int _currentImageIndex = 0;

  void _showSnack(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _updatePointers(int change) {
    globalPointers += change;
    if (globalPointers >= 2) {
      if (!globalPinchNotifier.value) globalPinchNotifier.value = true;
    } else {
      if (globalPinchNotifier.value) globalPinchNotifier.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<FeedBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Post Header
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          leading: CircleAvatar(
            backgroundColor: Colors.grey[800],
            backgroundImage: CachedNetworkImageProvider(widget.post.userImg),
          ),
          title: Text(
            widget.post.username,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          trailing: const Icon(Icons.more_vert, color: Colors.white),
        ),

        // Post Carousel
        Stack(
          alignment: Alignment.topRight,
          children: [
            Listener(
              onPointerDown: (_) => _updatePointers(1),
              onPointerUp: (_) => _updatePointers(-1),
              onPointerCancel: (_) => _updatePointers(-1),
              child: AspectRatio(
                aspectRatio:
                    0.75, //Changed as modern ig aspect ration is 3:4
                child: ValueListenableBuilder<bool>(
                  valueListenable: globalPinchNotifier,
                  builder: (context, isPinching, child) {
                    return PageView.builder(
                      physics: isPinching
                          ? const NeverScrollableScrollPhysics()
                          : const PageScrollPhysics(),
                      itemCount: widget.post.images.length,
                      onPageChanged: (index) =>
                          setState(() => _currentImageIndex = index),
                      itemBuilder: (context, index) =>
                          PinchToZoomImage(imageUrl: widget.post.images[index]),
                    );
                  },
                ),
              ),
            ),
            if (widget.post.images.length > 1)
              Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_currentImageIndex + 1}/${widget.post.images.length}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            // Carousel Dot Indicators
            if (widget.post.images.length > 1)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.post.images.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: _currentImageIndex == index ? 6 : 4,
                      height: _currentImageIndex == index ? 6 : 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentImageIndex == index
                            ? Color(0xFFAE44FD)
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              )
            else
              const Spacer(),
          ],
        ),
        // Post Actions
        Row(
          children: [
            IconButton(
              icon: FaIcon(
                widget.post.isLiked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
                color: widget.post.isLiked ? Colors.red : Colors.white,
              ),
              onPressed: () => bloc.add(TogglePostAction(widget.post.id, true)),
            ),
            IconButton(
              icon: FaIcon(FontAwesomeIcons.comment, color: Colors.white),
              onPressed: () => _showSnack(context, 'Comments clicked'),
            ),
            IconButton(
              icon: const HugeIcon(icon:HugeIcons.strokeRoundedRepeat, color: Colors.white , strokeWidth: 2),
              onPressed: () => _showSnack(context, 'Repost clicked'),
            ),
            IconButton(
              icon: const HugeIcon(icon:HugeIcons.strokeRoundedSent, color: Colors.white , strokeWidth: 2),
              onPressed: () => _showSnack(context, 'Share clicked'),
            ),
            
            const SizedBox(width: 140),

            IconButton(
              padding: EdgeInsets.zero,
              icon: FaIcon(
                widget.post.isSaved ? FontAwesomeIcons.solidBookmark : FontAwesomeIcons.bookmark,
                color: Colors.white,
              ),
              onPressed: () =>
                  bloc.add(TogglePostAction(widget.post.id, false)),
            ),
          ],
        ),

        // Caption
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${widget.post.username} ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: widget.post.caption,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
