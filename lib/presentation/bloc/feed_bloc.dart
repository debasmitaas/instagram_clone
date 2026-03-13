import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/post_repository.dart';
import 'feed_event.dart';
import 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final PostRepository repository;

  FeedBloc(this.repository) : super(FeedState(posts: [])) {
    on<LoadInitialFeed>((event, emit) async {
      emit(state.copyWith(isLoadingInitial: true));
      final posts = await repository.fetchPosts(page: 0);
      emit(state.copyWith(
        posts: posts,
        isLoadingInitial: false,
        currentPage: 0,
      ));
    });

    on<LoadMorePosts>((event, emit) async {
      if (state.isFetchingMore || state.hasReachedMax) return;
      emit(state.copyWith(isFetchingMore: true));
      
      final nextPage = state.currentPage + 1;
      final newPosts = await repository.fetchPosts(page: nextPage);
      
      if (newPosts.isEmpty) {
        emit(state.copyWith(hasReachedMax: true, isFetchingMore: false));
      } else {
        emit(state.copyWith(
          posts: List.of(state.posts)..addAll(newPosts),
          currentPage: nextPage,
          isFetchingMore: false,
        ));
      }
    });

    on<TogglePostAction>((event, emit) {
      final updatedPosts = state.posts.map((post) {
        if (post.id == event.postId) {
          return event.isLike
              ? post.copyWith(isLiked: !post.isLiked)
              : post.copyWith(isSaved: !post.isSaved);
        }
        return post;
      }).toList();
      emit(state.copyWith(posts: updatedPosts));
    });
  }
}