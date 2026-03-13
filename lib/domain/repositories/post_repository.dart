import '../models/post.dart';

class PostRepository {
  // Simulates a backend API call
  Future<List<Post>> fetchPosts({required int page, int limit = 10}) async {
    // Force a 1.5-second delay to demonstrate Shimmer
    await Future.delayed(const Duration(milliseconds: 1500));

    return List.generate(limit, (index) {
      final globalIndex = (page * limit) + index;
      return Post(
        id: globalIndex.toString(),
        username: 'user_$globalIndex',
        userImg: 'https://picsum.photos/seed/user$globalIndex/150',
        images: [
          'https://picsum.photos/seed/imgA$globalIndex/1080/1080',
          'https://picsum.photos/seed/imgB$globalIndex/1080/1080',
        ],
        caption: 'This is a beautiful moment captured in time! ✨📸 #nature #photography',
      );
    });
  }
}