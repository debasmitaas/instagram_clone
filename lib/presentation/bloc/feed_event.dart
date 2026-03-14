// lib/presentation/bloc/feed_event.dart
abstract class FeedEvent {}

class LoadInitialFeed extends FeedEvent {}

class LoadMorePosts extends FeedEvent {}

class TogglePostAction extends FeedEvent {
  final String postId;
  final bool isLike; // true for Like, false for Save
  TogglePostAction(this.postId, this.isLike);
}

class LoadCurrentUser extends FeedEvent {}