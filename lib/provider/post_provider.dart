<<<<<<< HEAD
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/posts_data.dart'; 

class PostProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  List<Post> _posts = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedCategory = 'Tất cả';
  String _searchQuery = '';

  StreamSubscription<List<Map<String, dynamic>>>? _postsSubscription;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;

  PostProvider() {
    fetchAndListenPosts();
  }

  Future<void> fetchPosts() async {
    fetchAndListenPosts();
  }

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

  // 3. Hàm kết nối Realtime Stream với Supabase
  void fetchAndListenPosts() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Hủy kết nối cũ nếu có trước khi tạo stream mới
    _postsSubscription?.cancel();

    try {
      _postsSubscription = _supabase
          .from('posts')
          .stream(primaryKey: ['id'])
          .order('id', ascending: true) // Sắp xếp theo ID
          .listen(
            (List<Map<String, dynamic>> data) {
              // Mỗi khi Supabase có INSERT/UPDATE/DELETE, stream sẽ trả về dữ liệu mới
              _posts = data.map((json) => Post.fromJson(json)).toList();
              _isLoading = false;
              _errorMessage = null;
              notifyListeners(); // Tự động cập nhật UI trên điện thoại
            },
            onError: (error) {
              _errorMessage = error.toString();
              _isLoading = false;
              print('Lỗi Realtime bài viết: $error');
              notifyListeners();
            },
          );
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
=======
import 'package:flutter/material.dart';
import '../data/posts_data.dart';

class PostProvider extends ChangeNotifier {
  // Lấy dữ liệu bài viết ban đầu
  final List<Post> _posts = samplePosts;

  List<Post> get posts => _posts;
>>>>>>> 250514a1eb6d282f5bbe3449101cb137c332e346

  // Hàm chuyển đổi trạng thái Thích (Like)
  void toggleLike(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      _posts[index].isLiked = !_posts[index].isLiked;
      _posts[index].likeCount += _posts[index].isLiked ? 1 : -1;
<<<<<<< HEAD
=======

      // Báo cho tất cả các Widget đang lắng nghe (PostsPage, PostDetailPage...) cập nhật lại UI
>>>>>>> 250514a1eb6d282f5bbe3449101cb137c332e346
      notifyListeners();
    }
  }

  // Hàm chuyển đổi trạng thái Lưu (Bookmark)
  void toggleBookmark(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      _posts[index].isBookMarked = !_posts[index].isBookMarked;
<<<<<<< HEAD
      notifyListeners();
    }
  }

  @override
  void dispose() {
    // Hủy Stream khi Provider bị hủy để tránh rò rỉ bộ nhớ (memory leak)
    _postsSubscription?.cancel();
    super.dispose();
  }
}
=======

      notifyListeners();
    }
  }
}
>>>>>>> 250514a1eb6d282f5bbe3449101cb137c332e346
