// lib/domain/repositories/post_repository.dart
import 'package:dio/dio.dart';
import '../models/post.dart';

class PostRepository {
  final Dio _dio = Dio();

  // Simulates a backend API call
  Future<List<Post>> fetchPosts({required int page, int limit = 10}) async {
    try {
      // 1. Actually test the network! 
      // In a real app, this would be: await _dio.get('https://api.instagram.com/posts?page=$page')
      // For now, we ping a highly available server just to verify internet existence. 
      // If the phone is offline, this immediately throws a DioException!
      await _dio.get('https://1.1.1.1', options: Options(
        sendTimeout: const Duration(seconds: 3),
        receiveTimeout: const Duration(seconds: 3),
      ));

      // 2. Force a 1.5-second delay to demonstrate Shimmer if the internet IS working
      await Future.delayed(const Duration(milliseconds: 1500));

      // 3. Generate the dummy data only if the network check succeeded
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
      
    } catch (e) {
      // If there is no internet, Dio throws an error, we catch it here, 
      // and rethrow it to the FeedBloc so it STOPS the infinite scrolling!
      rethrow; 
    }
  }
}