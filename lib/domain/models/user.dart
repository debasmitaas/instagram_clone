// lib/domain/models/user.dart
class User {
  final String id;
  final String username;
  final String profileImageUrl;
  final String bio;

  User({
    required this.id,
    required this.username,
    required this.profileImageUrl,
    required this.bio,
  });
}