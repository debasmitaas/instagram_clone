// lib/domain/repositories/user_repository.dart
import 'package:dio/dio.dart';
import '../models/user.dart';

class UserRepository {
  final Dio _dio = Dio();

  Future<User> getCurrentUser() async {
    try {
      // Simulate a 1-second network delay (like a real API call)
      await Future.delayed(const Duration(seconds: 1));

      // Mock current user with a random profile image from an API
      final randomUserId = DateTime.now().millisecondsSinceEpoch;
      
      return User(
        id: 'user_123',
        username: 'username123',
        profileImageUrl: 'https://picsum.photos/seed/user_$randomUserId/150',
        bio: 'Coffee lover ☕ | Photography 📸',
      );
      
      // In a real app, you would do:
      // final response = await _dio.get('https://api.example.com/user/me');
      // return User.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}