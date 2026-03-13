class Post {
  final String id;
  final String username;
  final String userImg;
  final List<String> images; // Multiple images for Carousel
  final String caption;
  final bool isLiked;
  final bool isSaved;

  Post({
    required this.id,
    required this.username,
    required this.userImg,
    required this.images,
    required this.caption,
    this.isLiked = false,
    this.isSaved = false,
  });

  Post copyWith({bool? isLiked, bool? isSaved}) {
    return Post(
      id: id,
      username: username,
      userImg: userImg,
      images: images,
      caption: caption,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}