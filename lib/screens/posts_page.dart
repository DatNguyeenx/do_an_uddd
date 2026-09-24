import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/post_provider.dart';
import 'posts_detail_page.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final Set<String> _selectedCategories = {'Tất cả'};
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _categories = const [
    'Tất cả',
    'Kinh nghiệm',
    'Ẩm thực',
    'Địa điểm',
  ];

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostProvider>().fetchPosts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getImageUrl(String postId) {
    final Map<String, String> imageMap = {
      '1': 'https://images.unsplash.com/photo-1528127269322-539801943592',
      '2': 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb',
      '3': 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1',
    };
    return imageMap[postId] ??
        'https://images.unsplash.com/photo-1528127269322-539801943592';
  }

  Widget _buildFeaturedCard(BuildContext context, dynamic post) {
    final imageUrl = _getImageUrl(post.id.toString());

    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostDetailPage(postId: post.id),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  post.author ?? '',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);

    final filteredPosts = postProvider.posts.where((post) {
      final matchesCategory = _selectedCategories.isEmpty ||
          _selectedCategories.contains('Tất cả') ||
          (post.categories as List).any(
            (cat) => _selectedCategories.contains(cat),
          );

      final query = _searchQuery.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          (post.title as String).toLowerCase().contains(query) ||
          (post.summary as String).toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // AppBar
          SliverAppBar(
            floating: true,
            pinned: true,
            snap: false,
            elevation: 0,
            scrolledUnderElevation: 1.0,
            backgroundColor: Colors.white,
            expandedHeight: 70.0,
            flexibleSpace: const FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 20, bottom: 16),
              title: Text(
                'Khám Phá Bài Viết',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Color(0xFF334155),
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Header Controls: Search & Category Chips
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm bài viết, chủ đề...',
                      hintStyle: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: Color(0xFF0F766E),
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear_rounded,
                                size: 18,
                                color: Color(0xFF94A3B8),
                              ),
                              onPressed: () => _searchController.clear(),
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 14),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide:
                            const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF0F766E),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),

                // Category Filter Chips
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = _selectedCategories.contains(cat);

                      return FilterChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (cat == 'Tất cả') {
                              _selectedCategories.clear();
                              _selectedCategories.add('Tất cả');
                            } else {
                              _selectedCategories.remove('Tất cả');
                              if (selected) {
                                _selectedCategories.add(cat);
                              } else {
                                _selectedCategories.remove(cat);
                              }
                              if (_selectedCategories.isEmpty) {
                                _selectedCategories.add('Tất cả');
                              }
                            }
                          });
                        },
                        selectedColor: const Color(0xFF0F766E),
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF475569),
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          fontSize: 13,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected
                                ? const Color(0xFF0F766E)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                        showCheckmark: false,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Featured Section
                if (_searchQuery.isEmpty &&
                    _selectedCategories.contains('Tất cả')) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Nổi Bật Trong Tuần 🔥',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: postProvider.posts.length > 3
                          ? 3
                          : postProvider.posts.length,
                      itemBuilder: (context, index) {
                        final post = postProvider.posts[index];
                        return _buildFeaturedCard(context, post);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Mới Cập Nhật',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),

          // Main Posts List / Loading Indicator / Empty State
          postProvider.isLoading
              ? const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF0F766E),
                    ),
                  ),
                )
              : filteredPosts.isEmpty
                  ? SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.article_outlined,
                              size: 64,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Không tìm thấy bài viết nào',
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      sliver: SliverList.builder(
                        itemCount: filteredPosts.length,
                        itemBuilder: (context, index) {
                          final post = filteredPosts[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFF1F5F9),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF0F172A)
                                      .withValues(alpha: 0.04),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PostDetailPage(postId: post.id),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Author Header
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 18,
                                            backgroundColor:
                                                const Color(0xFFCCFBF1),
                                            child: Text(
                                              (post.author as String)
                                                      .isNotEmpty
                                                  ? post.author[0]
                                                  : 'A',
                                              style: const TextStyle(
                                                color: Color(0xFF0F766E),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  post.author,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: Color(0xFF0F172A),
                                                  ),
                                                ),
                                                Wrap(
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  children: [
                                                    Text(
                                                      post.date,
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                        color:
                                                            Color(0xFF94A3B8),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    const Text(
                                                      '•',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color:
                                                            Color(0xFF94A3B8),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    const Icon(
                                                      Icons.access_time_rounded,
                                                      size: 11,
                                                      color: Color(0xFF94A3B8),
                                                    ),
                                                    const SizedBox(width: 2),
                                                    const Text(
                                                      '5 phút đọc',
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color:
                                                            Color(0xFF94A3B8),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              post.isBookMarked
                                                  ? Icons.bookmark_rounded
                                                  : Icons
                                                      .bookmark_border_rounded,
                                              color: post.isBookMarked
                                                  ? const Color(0xFF0F766E)
                                                  : const Color(0xFF94A3B8),
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              postProvider
                                                  .toggleBookmark(post.id);
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),

                                      // Post Content Title & Summary
                                      Text(
                                        post.title,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0F172A),
                                          height: 1.35,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        post.summary,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF64748B),
                                          height: 1.4,
                                        ),
                                      ),
                                      const SizedBox(height: 16),

                                      // Tags & Actions Row
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Wrap(
                                              spacing: 6,
                                              runSpacing: 4,
                                              children:
                                                  (post.categories as List)
                                                      .map((cat) {
                                                return Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 3,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFFCCFBF1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  child: Text(
                                                    '#$cat',
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Color(0xFF0F766E),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                onTap: () {
                                                  postProvider
                                                      .toggleLike(post.id);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 4,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        post.isLiked
                                                            ? Icons
                                                                .favorite_rounded
                                                            : Icons
                                                                .favorite_border_rounded,
                                                        size: 16,
                                                        color: post.isLiked
                                                            ? Colors.redAccent
                                                            : const Color(
                                                                0xFF64748B),
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        '${post.likeCount}',
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Color(0xFF64748B),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}