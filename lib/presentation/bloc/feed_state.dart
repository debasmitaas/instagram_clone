import '../../domain/models/post.dart';

class FeedState {
  final List<Post> posts;
  final bool isLoadingInitial;
  final bool isFetchingMore;
  final int currentPage;
  final bool hasReachedMax;

  FeedState({
    required this.posts,
    this.isLoadingInitial = false,
    this.isFetchingMore = false,
    this.currentPage = 0,
    this.hasReachedMax = false,
  });

  FeedState copyWith({
    List<Post>? posts,
    bool? isLoadingInitial,
    bool? isFetchingMore,
    int? currentPage,
    bool? hasReachedMax,
  }) {
    return FeedState(
      posts: posts ?? this.posts,
      isLoadingInitial: isLoadingInitial ?? this.isLoadingInitial,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}