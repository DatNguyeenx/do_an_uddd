import 'package:flutter/material.dart';
import '../data/posts_data.dart';

class PostProvider extends ChangeNotifier {
  List<Post> _posts = List<Post>.of(samplePosts);
  String _selectedCategory = 'Tất cả';
  String _searchQuery = '';

  PostProvider() {
    final now = DateTime.now();
    final date = '${now.day}/${now.month}/${now.year}';
    _posts.addAll([
      Post(
        id: 'community-demo-1',
        title: 'Mọi người thường đi Hội An vào thời điểm nào?',
        author: 'Minh Anh',
        date: date,
        summary: 'Mình đang lên lịch đi Hội An và muốn hỏi kinh nghiệm chọn thời gian.',
        content: 'Mình đang lên lịch đi Hội An lần đầu. Mọi người thường đi tháng nào để trời dễ chịu và phố cổ không quá đông?',
        categories: ['Hỏi đáp'],
        likeCount: 3,
        isCommunity: true,
      ),
      Post(
        id: 'community-demo-2',
        title: 'Một buổi sáng yên bình ở Đà Lạt',
        author: 'Thu Hà',
        date: date,
        summary: 'Chia sẻ một góc nhỏ trong chuyến đi gần đây.',
        content: 'Buổi sáng ở Đà Lạt, đi bộ quanh hồ rồi ghé một quán cà phê nhỏ. Không cần lịch trình dày đặc, chậm lại một chút cũng đủ thấy chuyến đi đáng nhớ.',
        categories: ['Kinh nghiệm'],
        likeCount: 8,
        isCommunity: true,
      ),
      Post(
        id: 'community-demo-3',
        title: 'Gợi ý món ngon khi ghé Huế',
        author: 'Quốc Bảo',
        date: date,
        summary: 'Một vài món mình đã thử trong chuyến đi.',
        content: 'Ngoài bún bò, mình rất thích cơm hến và bánh bèo ở Huế. Quán nhỏ trong hẻm cũng có nhiều món ngon, mọi người nhớ hỏi giá trước khi gọi nhé.',
        categories: ['Ẩm thực'],
        likeCount: 5,
        isCommunity: true,
      ),
    ]);
  }

  List<Post> get communityPosts =>
      _posts.where((post) => post.isCommunity).toList();

  List<Post> get posts => _posts;
  String get selectedCategory => _selectedCategory;

  // Lấy danh sách bài viết Nổi Bật (Nổi Bật Trong Tuần)
  List<Post> get featuredPosts {
    return _posts.where((p) => !p.isCommunity && p.likeCount >= 0).toList();
  }

  // Lấy danh sách bài viết theo Category + Search Query (Mới Cập Nhật)
  List<Post> get filteredPosts {
    return _posts.where((post) {
      if (post.isCommunity) return false;
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

  void addCommunityPost({
    required String author,
    required String title,
    required String content,
    required String category,
  }) {
    final now = DateTime.now();
    final date = '${now.day}/${now.month}/${now.year}';
    _posts.insert(
      0,
      Post(
        id: 'community-${now.microsecondsSinceEpoch}',
        title: title.trim(),
        author: author,
        date: date,
        summary: content.length > 160 ? '${content.substring(0, 160)}…' : content,
        content: content.trim(),
        categories: [category],
        likeCount: 0,
        isCommunity: true,
      ),
    );
    notifyListeners();
  }

  void deleteCommunityPost(String postId) {
    _posts.removeWhere((post) => post.id == postId && post.isCommunity);
    notifyListeners();
  }

}
