class Post {
  final String id;
  final String title;
  final String author;
  final String date;
  final String summary;
  final String content;
  final List<String> categories;

  bool isLiked;
  int likeCount;
  bool isBookMarked;

  Post({
    required this.id,
    required this.title,
    required this.author,
    required this.date,
    required this.summary,
    required this.content,
    required this.categories,
    this.isLiked = false,
    this.likeCount = 124,
    this.isBookMarked = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    // Đọc danh sách categories hoặc tags từ Supabase
    List<String> parsedCategories = [];
    if (json['categories'] != null) {
      parsedCategories = List<String>.from(json['categories']);
    } else if (json['tags'] != null) {
      parsedCategories = List<String>.from(json['tags']);
    }

    return Post(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      date: json['date'] ?? '',
      summary: json['summary'] ?? '',
      content: json['content'] ?? '',
      categories: parsedCategories,
      isLiked: json['is_liked'] ?? json['isLiked'] ?? false,
      likeCount: json['like_count'] ?? json['likeCount'] ?? 0,
      isBookMarked: json['is_bookmarked'] ?? json['isBookMarked'] ?? false,
    );
  }
}