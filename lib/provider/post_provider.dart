import 'package:flutter/material.dart';
import '../data/posts_data.dart';

class PostProvider extends ChangeNotifier {
  List<Post> _posts = List<Post>.of(samplePosts);
  String _selectedCategory = 'Tất cả';
  String _searchQuery = '';

  List<Post> get posts => _posts;
  String get selectedCategory => _selectedCategory;

  // Lấy danh sách bài viết Nổi Bật (Nổi Bật Trong Tuần)
  List<Post> get featuredPosts {
    return _posts.where((p) => p.likeCount >= 0).toList();
  }

  // Lấy danh sách bài viết theo Category + Search Query (Mới Cập Nhật)
  List<Post> get filteredPosts {
    return _posts.where((post) {
      // Kiểm tra danh mục
      bool matchesCategory = true;
      if (_selectedCategory != 'Tất cả') {
        matchesCategory = post.categories.any(
          (cat) => cat.toLowerCase() == _selectedCategory.toLowerCase(),
        );
      }

      // Kiểm tra tìm kiếm
      bool matchesSearch = true;
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        matchesSearch = post.title.toLowerCase().contains(query) ||
            post.summary.toLowerCase().contains(query);
      }

      return matchesCategory && matchesSearch;
    }).toList();
  }

  // Cập nhật danh mục được chọn
  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Cập nhật từ khóa tìm kiếm
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Hàm chuyển đổi trạng thái Thích (Like)
  void toggleLike(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      _posts[index].isLiked = !_posts[index].isLiked;
      _posts[index].likeCount += _posts[index].isLiked ? 1 : -1;
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
