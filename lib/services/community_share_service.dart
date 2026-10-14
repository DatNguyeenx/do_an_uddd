import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class CommunityShareService {
  static Future<void> sharePost({
    required BuildContext context,
    required String title,
    required String content,
  }) async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          text: '$title\n\n$content',
          subject: 'Bài viết từ cộng đồng Việt Đi',
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể mở chức năng chia sẻ trên thiết bị này.')),
      );
    }
  }
}
