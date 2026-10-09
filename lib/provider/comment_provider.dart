import 'package:flutter/material.dart';
import '../models/comment.dart';
import '../data/sample_comments.dart';

class CommentProvider extends ChangeNotifier {
  // Khởi tạo danh sách comment từ sampleComments
  final List<Comment> _comments = List.from(sampleComments);

  // 📍 Thêm biến lưu tên người dùng hiện tại dùng chung cho toàn ứng dụng
  String _currentAuthorName = 'Nguyễn Văn X';
  String get currentAuthorName => _currentAuthorName;

  List<Comment> get comments => _comments;

  // 📍 Cập nhật tên tác giả khi đổi ở trang cá nhân (dùng cho cả comment mới & cũ)
  void updateGlobalAuthorName(String newName) {
    if (_currentAuthorName == newName) return;

    final oldName = _currentAuthorName;
    _currentAuthorName = newName;

    // Đổi tên cho tất cả các comment/reply đã tồn tại trước đó
    void updateRecursive(List<Comment> commentList) {
      for (int i = 0; i < commentList.length; i++) {
        var comment = commentList[i];
        if (comment.author == oldName) {
          commentList[i] = comment.copyWith(author: newName);
        }
        if (comment.replies.isNotEmpty) {
          updateRecursive(comment.replies);
        }
      }
    }

    updateRecursive(_comments);
    notifyListeners();
  }

  // 📍 Lấy danh sách comment cấp 1 theo postId
  List<Comment> getCommentsByPostId(String postId) {
    return _comments
        .where((c) => c.postId == postId && c.parentId == null)
        .toList();
  }

  // 📍 Tính tổng số bình luận (gồm cả reply) của một bài viết
  int getCommentCount(String postId) {
    int total = 0;
    final postComments = _comments.where((c) => c.postId == postId);
    for (var comment in postComments) {
      total += 1 + comment.replies.length;
    }
    return total;
  }

  // 📍 Thêm Bình luận mới hoặc Trả lời (Reply) - Tự động lấy _currentAuthorName mới nhất
  void addComment({
    required String postId,
    required String content,
    String? parentId,
  }) {
    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: postId,
      author: _currentAuthorName, // Tự động lấy tên đang dùng trong Provider
      content: content,
      date: 'Vừa xong',
      parentId: parentId,
    );

    if (parentId == null) {
      _comments.insert(0, newComment);
    } else {
      final parentComment = _findCommentById(_comments, parentId);
      if (parentComment != null) {
        parentComment.replies.add(newComment);
      }
    }

    notifyListeners();
  }

  // 📍 Thả tim / Bỏ tim cho Comment hoặc Reply
  void toggleLikeComment(String commentId) {
    final targetComment = _findCommentById(_comments, commentId);
    if (targetComment != null) {
      targetComment.isLiked = !targetComment.isLiked;
      targetComment.likeCount += targetComment.isLiked ? 1 : -1;
      notifyListeners();
    }
  }

  // Hàm đệ quy tìm Comment theo ID (tìm cả trong replies)
  Comment? _findCommentById(List<Comment> list, String id) {
    for (var comment in list) {
      if (comment.id == id) return comment;
      if (comment.replies.isNotEmpty) {
        final found = _findCommentById(comment.replies, id);
        if (found != null) return found;
      }
    }
    return null;
  }
}
