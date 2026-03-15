// lib/presentation/bloc/feed_state.dart
import '../../domain/models/post.dart';
import '../../domain/models/user.dart';

class FeedState {
  final List<Post> posts;
  final bool isLoadingInitial;
  final bool isFetchingMore;
  final int currentPage;
  final bool hasReachedMax;
  final User? currentUser;
  final String? errorMessage; // <-- Added this

  FeedState({
    required this.posts,
    this.isLoadingInitial = false,
    this.isFetchingMore = false,
    this.currentPage = 0,
    this.hasReachedMax = false,
    this.currentUser,
    this.errorMessage, // <-- Added this
  });

  FeedState copyWith({
    List<Post>? posts,
    bool? isLoadingInitial,
    bool? isFetchingMore,
    int? currentPage,
    bool? hasReachedMax,
    User? currentUser,
    String? errorMessage, // <-- Added this
  }) {
    return FeedState(
      posts: posts ?? this.posts,
      isLoadingInitial: isLoadingInitial ?? this.isLoadingInitial,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentUser: currentUser ?? this.currentUser,
      errorMessage: errorMessage ?? this.errorMessage, // <-- Added this
    );
  }
}