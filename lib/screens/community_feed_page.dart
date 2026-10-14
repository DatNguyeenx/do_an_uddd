import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../models/comment.dart';
import '../provider/comment_provider.dart';
import '../provider/post_provider.dart';
import '../services/community_share_service.dart';
import 'create_community_post_page.dart';

class CommunityFeedPage extends StatefulWidget {
  const CommunityFeedPage({super.key});

  @override
  State<CommunityFeedPage> createState() => _CommunityFeedPageState();
}

class _CommunityFeedPageState extends State<CommunityFeedPage> {
  final _searchController = TextEditingController();
  String _query = '';
  String _category = 'Tất cả';
  bool _savedOnly = false;
  static const _categories = ['Tất cả', 'Kinh nghiệm', 'Ẩm thực', 'Địa điểm', 'Hỏi đáp'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _createPost() async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const CreateCommunityPostPage()),
    );
  }

  Future<void> _openComments(String postId) async {
    final controller = TextEditingController();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          4,
          16,
          MediaQuery.viewInsetsOf(sheetContext).bottom + 16,
        ),
        child: SizedBox(
          height: MediaQuery.sizeOf(sheetContext).height * .62,
          child: Column(
            children: [
              const Text('Bình luận', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const Divider(),
              Expanded(
                child: Consumer<CommentProvider>(
                  builder: (context, comments, _) {
                    final entries = comments.getCommentsByPostId(postId);
                    if (entries.isEmpty) return const Center(child: Text('Chưa có bình luận nào.'));
                    return ListView.builder(
                      itemCount: entries.length,
                      itemBuilder: (context, index) => _commentTile(context, comments, entries[index]),
                    );
                  },
                ),
              ),
              Row(children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    minLines: 1,
                    maxLines: 4,
                    maxLength: 2000,
                    decoration: const InputDecoration(
                      hintText: 'Viết bình luận…',
                      border: OutlineInputBorder(),
                      counterText: '',
                    ),
                  ),
                ),
                IconButton.filled(
                  onPressed: () {
                    final content = controller.text.trim();
                    if (content.isEmpty) return;
                    context.read<CommentProvider>().addComment(postId: postId, content: content);
                    controller.clear();
                  },
                  icon: const Icon(Icons.send),
                ),
              ]),
            ],
          ),
        ),
      ),
    ).whenComplete(controller.dispose);
  }

  Widget _commentTile(BuildContext context, CommentProvider provider, Comment comment) => ListTile(
        leading: const CircleAvatar(
          backgroundColor: AppColors.accent,
          child: Icon(Icons.person_outline, color: AppColors.primary),
        ),
        title: Text(comment.author, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(comment.content),
        trailing: IconButton(
          tooltip: 'Thích bình luận',
          onPressed: () => provider.toggleLikeComment(comment.id),
          icon: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(comment.isLiked ? Icons.favorite : Icons.favorite_border,
                color: comment.isLiked ? Colors.red : AppColors.textSecondary, size: 18),
            const SizedBox(width: 4),
            Text('${comment.likeCount}', style: const TextStyle(fontSize: 12)),
          ]),
        ),
      );

  Future<void> _deletePost(String postId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xóa bài viết?'),
        content: const Text('Bài viết sẽ bị xóa khỏi dữ liệu demo hiện tại.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Hủy')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Xóa')),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      context.read<PostProvider>().deleteCommunityPost(postId);
      context.read<CommentProvider>().removeCommentsForPost(postId);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Cộng đồng Việt Đi', style: TextStyle(fontWeight: FontWeight.w700)),
          actions: [
            IconButton(
              tooltip: _savedOnly ? 'Xem tất cả bài viết' : 'Bài đã lưu',
              onPressed: () => setState(() => _savedOnly = !_savedOnly),
              icon: Icon(_savedOnly ? Icons.bookmark : Icons.bookmark_border),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _createPost,
          icon: const Icon(Icons.edit_outlined),
          label: const Text('Đăng bài'),
        ),
        body: Consumer<PostProvider>(
          builder: (context, posts, _) {
            final commentProvider = context.watch<CommentProvider>();
            final query = _query.trim().toLowerCase();
            final visible = posts.communityPosts.where((post) {
              final matchesSearch = '${post.title} ${post.summary} ${post.author}'.toLowerCase().contains(query);
              final matchesCategory = _category == 'Tất cả' || post.categories.contains(_category);
              return matchesSearch && matchesCategory && (!_savedOnly || post.isBookMarked);
            }).toList();
            return Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _query = value),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Tìm bài viết hoặc tác giả',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 48,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  children: _categories.map((category) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: _category == category,
                      onSelected: (_) => setState(() => _category = category),
                    ),
                  )).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('${visible.length} bài viết${_savedOnly ? ' đã lưu' : ''} · Dữ liệu demo'),
              ),
              Expanded(
                child: visible.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(28),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.forum_outlined, size: 42, color: AppColors.textSecondary),
                              const SizedBox(height: 12),
                              Text(_savedOnly ? 'Bạn chưa lưu bài viết cộng đồng nào.' : 'Chưa có bài viết cộng đồng. Hãy chia sẻ điều đầu tiên!'),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 92),
                        itemCount: visible.length,
                        itemBuilder: (context, index) {
                          final post = visible[index];
                          final comments = commentProvider.getCommentCount(post.id);
                          return Card(
                            color: AppColors.surface,
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Row(children: [
                                  const CircleAvatar(backgroundColor: AppColors.accent, child: Icon(Icons.person, color: AppColors.primary)),
                                  const SizedBox(width: 10),
                                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text(post.author, style: const TextStyle(fontWeight: FontWeight.w700)),
                                    Text('${post.date} · ${post.categories.join(' · ')}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                                  ])),
                                  PopupMenuButton<String>(
                                    onSelected: (value) { if (value == 'delete') _deletePost(post.id); },
                                    itemBuilder: (_) => const [PopupMenuItem(value: 'delete', child: Text('Xóa bài viết'))],
                                  ),
                                ]),
                                const SizedBox(height: 12),
                                Text(post.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 8),
                                Text(post.content, maxLines: 6, overflow: TextOverflow.ellipsis, style: const TextStyle(height: 1.5)),
                                const Divider(height: 24),
                                Wrap(alignment: WrapAlignment.spaceAround, spacing: 8, children: [
                                  TextButton.icon(
                                    onPressed: () => posts.toggleLike(post.id),
                                    icon: Icon(post.isLiked ? Icons.favorite : Icons.favorite_border, color: post.isLiked ? Colors.red : AppColors.primary),
                                    label: Text('${post.likeCount}'),
                                  ),
                                  TextButton.icon(
                                    onPressed: () => _openComments(post.id),
                                    icon: const Icon(Icons.chat_bubble_outline),
                                    label: Text('$comments bình luận'),
                                  ),
                                  IconButton(
                                    tooltip: post.isBookMarked ? 'Bỏ lưu' : 'Lưu bài',
                                    onPressed: () => posts.toggleBookmark(post.id),
                                    icon: Icon(post.isBookMarked ? Icons.bookmark : Icons.bookmark_border),
                                  ),
                                  IconButton(
                                    tooltip: 'Chia sẻ',
                                    onPressed: () => CommunityShareService.sharePost(context: context, title: post.title, content: post.content),
                                    icon: const Icon(Icons.share_outlined),
                                  ),
                                ]),
                              ]),
                            ),
                          );
                        },
                      ),
              ),
            ]);
          },
        ),
      );
}
