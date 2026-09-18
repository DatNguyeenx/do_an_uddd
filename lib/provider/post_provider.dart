import 'package:flutter/material.dart';
import '../data/posts_data.dart';

class PostProvider extends ChangeNotifier {
  // Lấy dữ liệu bài viết ban đầu
  final List<Post> _posts = samplePosts;

  List<Post> get posts => _posts;

  // Hàm chuyển đổi trạng thái Thích (Like)
  void toggleLike(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      _posts[index].isLiked = !_posts[index].isLiked;
      _posts[index].likeCount += _posts[index].isLiked ? 1 : -1;

      // Báo cho tất cả các Widget đang lắng nghe (PostsPage, PostDetailPage...) cập nhật lại UI
      notifyListeners();
    }
  }

  // Hàm chuyển đổi trạng thái Lưu (Bookmark)
  void toggleBookmark(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      _posts[index].isBookMarked = !_posts[index].isBookMarked;

      notifyListeners();
    }
  }
}
