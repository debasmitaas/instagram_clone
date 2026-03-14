// lib/presentation/widgets/post_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../domain/models/post.dart';
import '../bloc/feed_bloc.dart';
import '../bloc/feed_event.dart';
import 'double_tap_like_wrapper.dart';
import 'pinch_to_zoom_image.dart';

class PostWidget extends StatefulWidget {
  final Post post;
  const PostWidget({super.key, required this.post});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget>
    with SingleTickerProviderStateMixin {
  int _currentImageIndex = 0;

  late AnimationController _smallHeartController;
  late Animation<double> _smallHeartScale;

  @override
  void initState() {
    super.initState();

    _smallHeartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Rubber-band bounce: pop out → overshoot down → settle
    _smallHeartScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.4)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.4, end: 0.85)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.85, end: 1.1)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.1, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 20,
      ),
    ]).animate(_smallHeartController);
  }

  @override
  void dispose() {
    _smallHeartController.dispose();
    super.dispose();
  }

  void _showSnack(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    ));
  }

  void _handleLikeAction(BuildContext context, {bool isDoubleTap = false}) {
    final bloc = context.read<FeedBloc>();
    if (!widget.post.isLiked || !isDoubleTap) {
      bloc.add(TogglePostAction(widget.post.id, true));
    }
    // Bounce the button on every like action — double-tap OR button press
    _smallHeartController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<FeedBloc>();
    // FIX: Use screen width to compute image height at Instagram's 4:5 ratio.
    // This prevents the shimmer/placeholder from reserving wrong height,
    // eliminating the black gap that appeared before the image loaded.
    final imageHeight = MediaQuery.of(context).size.width * (5 / 4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ────────────────────────────────────────────
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          leading: CircleAvatar(
            backgroundColor: Colors.grey[800],
            backgroundImage: CachedNetworkImageProvider(widget.post.userImg),
          ),
          title: Text(
            widget.post.username,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
          trailing: const Icon(Icons.more_vert, color: Colors.white),
        ),

        // ── Carousel ──────────────────────────────────────────
        Stack(
          children: [
            SizedBox(
              height: imageHeight,
              child: PageView.builder(
                physics: const PageScrollPhysics(),
                itemCount: widget.post.images.length,
                onPageChanged: (index) =>
                    setState(() => _currentImageIndex = index),
                itemBuilder: (context, index) {
                  return DoubleTapLikeWrapper(
                    onLike: () =>
                        _handleLikeAction(context, isDoubleTap: true),
                    child: PinchToZoomImage(
                      imageUrl: widget.post.images[index],
                    ),
                  );
                },
              ),
            ),

            // Image counter pill (top-right)
            if (widget.post.images.length > 1)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_currentImageIndex + 1}/${widget.post.images.length}',
                    style:
                        const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 10),

        // ── Dot indicators ────────────────────────────────────
        if (widget.post.images.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.post.images.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: _currentImageIndex == index ? 6 : 4,
                height: _currentImageIndex == index ? 6 : 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentImageIndex == index
                      ? const Color(0xFFAE44FD)
                      : Colors.grey,
                ),
              ),
            ),
          ),

        // ── Action buttons ────────────────────────────────────
        Row(
          children: [
            ScaleTransition(
              scale: _smallHeartScale,
              child: IconButton(
                icon: FaIcon(
                  widget.post.isLiked
                      ? FontAwesomeIcons.solidHeart
                      : FontAwesomeIcons.heart,
                  color: widget.post.isLiked ? Colors.red : Colors.white,
                ),
                onPressed: () =>
                    _handleLikeAction(context, isDoubleTap: false),
              ),
            ),
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.comment, color: Colors.white),
              onPressed: () => _showSnack(context, 'Comments clicked'),
            ),
            IconButton(
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedRepeat,
                color: Colors.white,
                strokeWidth: 2,
              ),
              onPressed: () => _showSnack(context, 'Repost clicked'),
            ),
            IconButton(
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedSent,
                color: Colors.white,
                strokeWidth: 2,
              ),
              onPressed: () => _showSnack(context, 'Share clicked'),
            ),
            const Spacer(),
            IconButton(
              padding: EdgeInsets.zero,
              icon: FaIcon(
                widget.post.isSaved
                    ? FontAwesomeIcons.solidBookmark
                    : FontAwesomeIcons.bookmark,
                color: Colors.white,
              ),
              onPressed: () =>
                  bloc.add(TogglePostAction(widget.post.id, false)),
            ),
          ],
        ),

        // ── Caption ───────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${widget.post.username} ',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
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