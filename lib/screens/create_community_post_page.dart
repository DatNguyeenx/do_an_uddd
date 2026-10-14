import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../provider/post_provider.dart';
import '../provider/profile_provider.dart';

class CreateCommunityPostPage extends StatefulWidget {
  const CreateCommunityPostPage({super.key});

  @override
  State<CreateCommunityPostPage> createState() => _CreateCommunityPostPageState();
}

class _CreateCommunityPostPageState extends State<CreateCommunityPostPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _content = TextEditingController();
  String _category = 'Kinh nghiệm';
  static const _categories = ['Kinh nghiệm', 'Ẩm thực', 'Địa điểm', 'Hỏi đáp'];

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<PostProvider>().addCommunityPost(
          author: context.read<ProfileProvider>().name,
          title: _title.text.trim(),
          content: _content.text.trim(),
          category: _category,
        );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Đăng bài cộng đồng')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(children: [
                const CircleAvatar(
                  backgroundColor: AppColors.accent,
                  child: Icon(Icons.person, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(context.watch<ProfileProvider>().name,
                    style: const TextStyle(fontWeight: FontWeight.w700))),
              ]),
              const SizedBox(height: 20),
              TextFormField(
                controller: _title,
                maxLength: 150,
                decoration: const InputDecoration(
                  labelText: 'Tiêu đề',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value ?? '').trim().length < 5
                    ? 'Tiêu đề cần ít nhất 5 ký tự.'
                    : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(
                  labelText: 'Danh mục',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    )).toList(),
                onChanged: (value) => setState(() => _category = value ?? _category),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _content,
                minLines: 6,
                maxLines: 12,
                maxLength: 10000,
                decoration: const InputDecoration(
                  labelText: 'Nội dung',
                  hintText: 'Chia sẻ kinh nghiệm hoặc đặt câu hỏi…',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) => (value ?? '').trim().length < 10
                    ? 'Nội dung cần ít nhất 10 ký tự.'
                    : null,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.send_outlined),
                label: const Text('Đăng bài'),
              ),
              const SizedBox(height: 8),
              const Text(
                'Bài đăng được lưu tạm trong bộ nhớ của ứng dụng.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ),
      );
}
