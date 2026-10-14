import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/admin_provider.dart';

const _teal = Color(0xFF0F766E);
const _ink = Color(0xFF0F172A);
const _muted = Color(0xFF64748B);
const _line = Color(0xFFE2E8F0);
const _tealSoft = Color(0xFFE6F7F4);
const _tealLight = Color(0xFFCCFBF1);

const _sections = [
  'Tổng quan',
  'Địa danh',
  'Tỉnh/thành',
  'Loại hình',
  'Bài viết',
  'Đánh giá',
  'Tài khoản',
];
const _icons = [
  Icons.space_dashboard_outlined,
  Icons.place_outlined,
  Icons.location_city_outlined,
  Icons.category_outlined,
  Icons.article_outlined,
  Icons.star_outline,
  Icons.people_outline,
];

BoxDecoration _cardDecoration() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(14),
  border: Border.all(color: _line),
);

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int selected = 0;
  bool collapsed = false;

  String get page => _sections[selected];

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 760;
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      // FIX: drawer phải dùng sidebar dạng mở rộng
      drawer: narrow ? Drawer(width: 248, child: _sidebar(true)) : null,
      body: Row(
        children: [
          if (!narrow) _sidebar(!collapsed),
          Expanded(
            child: Column(
              children: [
                _topbar(narrow),
                Expanded(
                  child: Consumer<AdminProvider>(
                    builder: (context, data, _) =>
                        selected == 0 ? _overview(data) : _manager(data, page),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Sidebar
  Widget _sidebar(bool expanded) => Container(
    width: expanded ? 248 : 78,
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(expanded ? 22 : 17, 22, 12, 26),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _tealLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.explore, color: _teal),
              ),
              if (expanded) ...[
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Việt Đi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: _ink,
                      ),
                    ),
                    Text(
                      'ADMIN CONSOLE',
                      style: TextStyle(
                        fontSize: 9,
                        letterSpacing: 1.2,
                        color: _muted,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        if (expanded)
          const Padding(
            padding: EdgeInsets.fromLTRB(22, 0, 12, 10),
            child: Text(
              'MENU',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                color: _muted,
              ),
            ),
          ),
        ...List.generate(_sections.length, (i) => _menuItem(i, expanded)),
        const Spacer(),
        if (expanded)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 17,
                    backgroundColor: _tealLight,
                    child: Icon(Icons.person, color: _teal, size: 18),
                  ),
                  SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quản trị viên',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'admin@vietdi.demo',
                          style: TextStyle(color: _muted, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.more_horiz, color: _muted),
                ],
              ),
            ),
          )
        else
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Icon(Icons.person_outline, color: _muted),
          ),
      ],
    ),
  );

  Widget _menuItem(int i, bool expanded) {
    final active = selected == i;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: expanded ? 12 : 9, vertical: 2),
      child: Tooltip(
        message: _sections[i],
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            setState(() => selected = i);
            // Đóng drawer nếu đang ở màn hình hẹp
            if (MediaQuery.sizeOf(context).width < 760 &&
                Scaffold.of(context).isDrawerOpen) {
              Navigator.pop(context);
            }
          },
          child: Container(
            height: 44,
            padding: EdgeInsets.symmetric(horizontal: expanded ? 12 : 0),
            decoration: BoxDecoration(
              color: active ? _tealSoft : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: expanded
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                Icon(_icons[i], size: 19, color: active ? _teal : _muted),
                if (expanded) ...[
                  const SizedBox(width: 12),
                  Text(
                    _sections[i],
                    style: TextStyle(
                      color: active ? _teal : const Color(0xFF334155),
                      fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Topbar
  Widget _topbar(bool narrow) => Container(
    height: 72,
    padding: const EdgeInsets.symmetric(horizontal: 24),
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(bottom: BorderSide(color: _line)),
    ),
    child: Row(
      children: [
        if (narrow)
          Builder(
            builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu),
            ),
          )
        else
          IconButton(
            tooltip: collapsed ? 'Mở rộng menu' : 'Thu gọn menu',
            onPressed: () => setState(() => collapsed = !collapsed),
            icon: const Icon(Icons.menu_open, color: _muted),
          ),
        Expanded(
          child: Text(
            page == 'Tổng quan' ? 'Không gian quản trị' : 'Quản lý $page',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _ink,
            ),
          ),
        ),
        const Tooltip(
          message: 'Bản mô phỏng dùng dữ liệu trong bộ nhớ',
          child: Icon(Icons.notifications_none, color: _muted),
        ),
        const SizedBox(width: 18),
        const CircleAvatar(
          radius: 17,
          backgroundColor: _tealLight,
          child: Icon(Icons.person, color: _teal, size: 18),
        ),
        const SizedBox(width: 9),
        if (!narrow)
          const Text(
            'Admin',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
        const SizedBox(width: 6),
        PopupMenuButton<String>(
          tooltip: 'Tài khoản',
          onSelected: (v) {
            if (v == 'logout') {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (_) => false,
              );
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'logout', child: Text('Đăng xuất demo')),
          ],
          child: const Icon(Icons.expand_more, color: _muted),
        ),
      ],
    ),
  );

  // Tổng quan
  Widget _overview(AdminProvider data) => LayoutBuilder(
    builder: (context, box) {
      final cols = box.maxWidth > 1100 ? 4 : (box.maxWidth > 650 ? 2 : 1);
      // FIX: trừ padding 28 * 2 của ListView
      final w = box.maxWidth - 56;
      final stats = [
        ('Địa danh', data.of('Địa danh').length, Icons.place_outlined),
        (
          'Tỉnh/thành',
          data.of('Tỉnh/thành').length,
          Icons.location_city_outlined,
        ),
        ('Bài viết', data.of('Bài viết').length, Icons.article_outlined),
        ('Tài khoản', data.of('Tài khoản').length, Icons.people_outline),
      ];
      return ListView(
        padding: const EdgeInsets.all(28),
        children: [
          const Text(
            'Chào buổi sáng, Admin 👋',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: _ink,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Đây là tình hình nội dung trên Việt Đi hôm nay.',
            style: TextStyle(color: _muted),
          ),
          const SizedBox(height: 24),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: cols,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: cols == 1 ? 4.0 : 1.8,
            children: stats
                .map((s) => _statCard(s.$1, '${s.$2}', s.$3))
                .toList(),
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              SizedBox(
                width: w > 900 ? (w - 16) * .57 : w,
                child: _recentCard(data),
              ),
              SizedBox(
                width: w > 900 ? (w - 16) * .43 : w,
                child: _activityCard(data),
              ),
            ],
          ),
        ],
      );
    },
  );

  Widget _statCard(String label, String value, IconData icon) => Container(
    padding: const EdgeInsets.all(18),
    decoration: _cardDecoration(),
    child: Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: _tealSoft,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: _teal),
        ),
        const SizedBox(width: 13),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: _muted, fontSize: 12)),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: _ink,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _recentCard(AdminProvider data) => Container(
    padding: const EdgeInsets.all(20),
    decoration: _cardDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Địa danh cập nhật gần đây',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        ...data
            .of('Địa danh')
            .take(5)
            .map(
              (p) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: _tealSoft,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(
                        Icons.landscape_outlined,
                        color: _teal,
                        size: 19,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${p.values['Tỉnh/thành'] ?? '—'} · ${p.values['Loại hình'] ?? '—'}',
                            style: const TextStyle(color: _muted, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${p.values['Đánh giá'] ?? '0.0'} ★',
                      style: const TextStyle(
                        color: Color(0xFFB7791F),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ],
    ),
  );

  Widget _activityCard(AdminProvider data) {
    final reviews = data.of('Đánh giá');
    final avg = reviews.isEmpty
        ? '—'
        : (reviews
                      .map((r) => double.tryParse(r.values['Điểm'] ?? '0') ?? 0)
                      .reduce((a, b) => a + b) /
                  reviews.length)
              .toStringAsFixed(1);
    final posts = data.of('Bài viết');
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hoạt động cộng đồng',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _metric('Đánh giá', '${reviews.length}')),
              Expanded(child: _metric('Điểm trung bình', avg)),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Phân bố bài viết',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ...['Đã xuất bản', 'Bản nháp', 'Đã ẩn'].map((status) {
            final n = posts.where((e) => e.status == status).length;
            final total = posts.length;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          status,
                          style: const TextStyle(fontSize: 11, color: _muted),
                        ),
                      ),
                      Text(
                        '$n',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  LinearProgressIndicator(
                    value: total == 0 ? 0 : n / total,
                    minHeight: 5,
                    backgroundColor: _line,
                    color: _teal,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _metric(String title, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        value,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: _teal,
        ),
      ),
      Text(title, style: const TextStyle(fontSize: 11, color: _muted)),
    ],
  );

  // Quản lý
  Widget _manager(AdminProvider data, String section) => _ManagerPage(
    key: ValueKey(section), // FIX: reset query/filters khi đổi mục
    section: section,
    data: data,
    onCreate: () => _edit(data, section, null),
    onEdit: (row) => _edit(data, section, row),
  );

  Future<void> _edit(
    AdminProvider data,
    String section,
    AdminRecord? record,
  ) async {
    final fields = _fields(section);
    final choices = {for (final f in fields) f: _choices(section, f, data)};
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => _RecordDialog(
        section: section,
        fields: fields,
        choices: choices,
        record: record,
      ),
    );
    if (result == null || !mounted) return;
    data.save(section, record, result);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          record == null ? 'Đã thêm dữ liệu demo' : 'Đã cập nhật dữ liệu demo',
        ),
      ),
    );
  }

  List<String> _fields(String section) => switch (section) {
    'Địa danh' => [
      'Tên',
      'Tỉnh/thành',
      'Loại hình',
      'Địa chỉ',
      'Mô tả',
      'Vĩ độ',
      'Kinh độ',
      'Ảnh',
      'Trạng thái',
    ],
    'Tỉnh/thành' => ['Tên', 'Mô tả'],
    'Loại hình' => ['Tên', 'Mô tả'],
    'Bài viết' => [
      'Tiêu đề',
      'Tác giả',
      'Mô tả ngắn',
      'Nội dung',
      'Ảnh',
      'Ngày cập nhật',
      'Trạng thái',
    ],
    'Đánh giá' => [
      'Người dùng',
      'Địa danh',
      'Điểm',
      'Nội dung',
      'Ngày gửi',
      'Trạng thái',
    ],
    _ => ['Người dùng', 'Email', 'Vai trò', 'Trạng thái', 'Ngày tham gia'],
  };

  List<String> _choices(String section, String field, AdminProvider data) =>
      switch (field) {
        'Tỉnh/thành' => data.of('Tỉnh/thành').map((r) => r.title).toList(),
        'Loại hình' => data.of('Loại hình').map((r) => r.title).toList(),
        'Trạng thái' => switch (section) {
          'Địa danh' => ['Đang hiển thị', 'Đã ẩn'],
          'Bài viết' => ['Đã xuất bản', 'Bản nháp', 'Đã ẩn'],
          'Đánh giá' => ['Đang hiển thị', 'Đã ẩn'],
          _ => ['Hoạt động', 'Đã khóa'],
        },
        'Vai trò' => ['Thành viên', 'Admin'],
        _ => <String>[],
      };
}

//Dialog thêm / sửa
///
class _RecordDialog extends StatefulWidget {
  const _RecordDialog({
    required this.section,
    required this.fields,
    required this.choices,
    required this.record,
  });

  final String section;
  final List<String> fields;
  final Map<String, List<String>> choices;
  final AdminRecord? record;

  @override
  State<_RecordDialog> createState() => _RecordDialogState();
}

class _RecordDialogState extends State<_RecordDialog> {
  final form = GlobalKey<FormState>();
  late final Map<String, TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = {
      for (final f in widget.fields)
        f: TextEditingController(
          text: widget.record?.values[f] ?? _defaultFor(f),
        ),
    };
  }

  String _defaultFor(String field) {
    final list = widget.choices[field] ?? const <String>[];
    return field == 'Trạng thái' && list.isNotEmpty ? list.first : '';
  }

  @override
  void dispose() {
    for (final c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!form.currentState!.validate()) return;
    Navigator.pop(context, {
      for (final e in controllers.entries) e.key: e.value.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final fields = widget.fields;
    final width = fields.length > 3 ? 270.0 : 560.0;
    const optional = ['Vĩ độ', 'Kinh độ', 'Ảnh'];
    const multiline = ['Mô tả', 'Nội dung', 'Mô tả ngắn'];

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 650, maxHeight: 800),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.record == null
                            ? 'Thêm ${widget.section}'
                            : 'Chỉnh sửa ${widget.section}',
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 14,
                      runSpacing: 12,
                      children: fields.map((field) {
                        final list = widget.choices[field] ?? const <String>[];
                        final decoration = InputDecoration(
                          labelText: field,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          isDense: true,
                        );
                        String? validator(String? v) =>
                            optional.contains(field) ||
                                (v != null && v.trim().isNotEmpty)
                            ? null
                            : 'Vui lòng nhập $field';

                        if (list.isNotEmpty) {
                          final current = controllers[field]!.text;
                          return SizedBox(
                            width: width,
                            child: DropdownButtonFormField<String>(
                              initialValue: list.contains(current)
                                  ? current
                                  : null,
                              decoration: decoration,
                              items: list
                                  .map(
                                    (v) => DropdownMenuItem(
                                      value: v,
                                      child: Text(v),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) =>
                                  controllers[field]!.text = v ?? '',
                              validator: validator,
                            ),
                          );
                        }
                        return SizedBox(
                          width: width,
                          child: TextFormField(
                            controller: controllers[field],
                            maxLines: multiline.contains(field) ? 4 : 1,
                            decoration: decoration,
                            validator: validator,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Hủy'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: _teal),
                      onPressed: _submit,
                      child: const Text('Lưu thay đổi'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//  Trang quản lý (bảng)
class _ManagerPage extends StatefulWidget {
  const _ManagerPage({
    super.key,
    required this.section,
    required this.data,
    required this.onCreate,
    required this.onEdit,
  });

  final String section;
  final AdminProvider data;
  final VoidCallback onCreate;
  final void Function(AdminRecord row) onEdit;

  @override
  State<_ManagerPage> createState() => _ManagerPageState();
}

class _ManagerPageState extends State<_ManagerPage> {
  String query = '';
  final Map<String, String> filters = {};

  bool get _canCreate =>
      widget.section != 'Đánh giá' && widget.section != 'Tài khoản';

  @override
  Widget build(BuildContext context) {
    final all = widget.data.of(widget.section);
    final filterFields = switch (widget.section) {
      'Địa danh' => ['Tỉnh/thành', 'Loại hình'],
      'Bài viết' || 'Đánh giá' || 'Tài khoản' => ['Trạng thái'],
      _ => const <String>[],
    };
    final visible = all.where((r) {
      final matchText = r.values.values
          .join(' ')
          .toLowerCase()
          .contains(query.toLowerCase());
      final matchFilter = filterFields.every(
        (f) =>
            filters[f] == null ||
            filters[f] == 'Tất cả' ||
            r.values[f] == filters[f],
      );
      return matchText && matchFilter;
    }).toList();

    return LayoutBuilder(
      builder: (context, box) => ListView(
        padding: EdgeInsets.all(box.maxWidth < 700 ? 16 : 28),
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quản lý ${widget.section.toLowerCase()}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: _ink,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _description(widget.section),
                      style: const TextStyle(color: _muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (_canCreate)
                FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: _teal),
                  onPressed: widget.onCreate,
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(
                    box.maxWidth < 600
                        ? 'Thêm'
                        : 'Thêm ${widget.section.toLowerCase()}',
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: _cardDecoration(),
            child: Wrap(
              spacing: 12,
              runSpacing: 10,
              children: [
                SizedBox(
                  width: box.maxWidth > 700 ? 300 : box.maxWidth - 60,
                  height: 42,
                  child: TextField(
                    onChanged: (v) => setState(() => query = v),
                    decoration: InputDecoration(
                      hintText: 'Tìm trong ${widget.section.toLowerCase()}...',
                      prefixIcon: const Icon(Icons.search, size: 19),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.all(10),
                    ),
                  ),
                ),
                ...filterFields.map((field) {
                  final options = all
                      .map((e) => e.values[field])
                      .whereType<String>()
                      .toSet()
                      .toList();
                  return SizedBox(
                    width: 190,
                    height: 42,
                    child: DropdownButtonFormField<String>(
                      initialValue: filters[field] ?? 'Tất cả',
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: field,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: ['Tất cả', ...options]
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e, overflow: TextOverflow.ellipsis),
                            ),
                          )
                          .toList(),
                      onChanged: (v) =>
                          setState(() => filters[field] = v ?? 'Tất cả'),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (visible.isEmpty)
            _empty()
          else
            _table(context, visible, box.maxWidth),
        ],
      ),
    );
  }

  String _description(String s) => switch (s) {
    'Địa danh' => 'Quản lý các điểm đến và thông tin hiển thị trên ứng dụng.',
    'Tỉnh/thành' => 'Danh mục địa phương liên kết với các địa danh.',
    'Loại hình' => 'Phân loại trải nghiệm du lịch.',
    'Bài viết' => 'Quản lý nội dung cẩm nang du lịch.',
    'Đánh giá' => 'Kiểm duyệt phản hồi của cộng đồng.',
    'Tài khoản' => 'Theo dõi trạng thái tài khoản người dùng.',
    _ => 'Thông tin quản trị nội bộ.', // FIX: wildcard đúng cú pháp
  };

  Widget _empty() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(50),
    decoration: _cardDecoration(),
    child: const Column(
      children: [
        Icon(Icons.search_off, color: _muted, size: 36),
        SizedBox(height: 10),
        Text('Không tìm thấy dữ liệu phù hợp', style: TextStyle(color: _muted)),
      ],
    ),
  );

  List<String> _columns() => switch (widget.section) {
    'Địa danh' => ['Tên', 'Tỉnh/thành', 'Loại hình', 'Đánh giá', 'Trạng thái'],
    'Tỉnh/thành' => ['Tên', 'Số địa danh', 'Mô tả'],
    'Loại hình' => ['Tên', 'Số địa danh', 'Mô tả'],
    'Bài viết' => ['Tiêu đề', 'Tác giả', 'Ngày cập nhật', 'Trạng thái'],
    'Đánh giá' => [
      'Người dùng',
      'Địa danh',
      'Điểm',
      'Nội dung',
      'Ngày gửi',
      'Trạng thái',
    ],
    _ => ['Người dùng', 'Email', 'Vai trò', 'Trạng thái', 'Ngày tham gia'],
  };

  Widget _table(BuildContext context, List<AdminRecord> rows, double width) {
    final columns = _columns();
    const headStyle = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: _muted,
    );

    return Container(
      decoration: _cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
          columnSpacing: width < 650 ? 20 : 32,
          horizontalMargin: 18,
          columns: [
            ...columns.map((c) => DataColumn(label: Text(c, style: headStyle))),
            const DataColumn(label: Text('Thao tác', style: headStyle)),
          ],
          rows: rows
              .map(
                (r) => DataRow(
                  cells: [
                    ...columns.map((c) => _cell(r, c)),
                    DataCell(_actions(context, r)),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  DataCell _cell(AdminRecord r, String c) {
    final value = r.values[c] ?? '—';

    if (c == 'Trạng thái') return DataCell(_status(value));

    if (c == 'Đánh giá' || c == 'Điểm') {
      return DataCell(
        Text(
          '$value ★',
          style: const TextStyle(
            color: Color(0xFFB7791F),
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    if (c == 'Tên' && widget.section == 'Địa danh') {
      final url = r.values['Ảnh'] ?? '';
      Widget placeholder() => Container(
        width: 40,
        height: 34,
        color: _tealSoft,
        child: const Icon(Icons.landscape_outlined, color: _teal, size: 18),
      );
      return DataCell(
        SizedBox(
          width: 190,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: url.isEmpty
                    ? placeholder()
                    : Image.network(
                        url,
                        width: 40,
                        height: 34,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) => placeholder(),
                      ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _ink,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final bold = c == 'Tên' || c == 'Tiêu đề' || c == 'Người dùng';
    return DataCell(
      SizedBox(
        width: c == 'Nội dung' ? 230 : (c == 'Tiêu đề' ? 260 : 180),
        child: Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
            color: _ink,
          ),
        ),
      ),
    );
  }

  Widget _status(String value) {
    final good = ['Đang hiển thị', 'Đã xuất bản', 'Hoạt động'].contains(value);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: good ? const Color(0xFFDCFCE7) : const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: good ? const Color(0xFF15803D) : const Color(0xFFC2410C),
        ),
      ),
    );
  }

  Widget _actions(BuildContext context, AdminRecord row) {
    final s = widget.section;
    final canEditDelete = s != 'Đánh giá' && s != 'Tài khoản';
    return PopupMenuButton<String>(
      tooltip: 'Thao tác',
      icon: const Icon(Icons.more_horiz, color: _muted),
      onSelected: (action) {
        switch (action) {
          case 'edit':
            widget.onEdit(row); // FIX: không còn findAncestorStateOfType
          case 'delete':
            _confirmDelete(context, row);
          case 'toggle':
            _toggle(row);
          case 'preview':
            _preview(context, row);
        }
      },
      itemBuilder: (_) => [
        if (canEditDelete)
          const PopupMenuItem(value: 'edit', child: Text('Chỉnh sửa')),
        if (s == 'Bài viết') ...const [
          PopupMenuItem(value: 'preview', child: Text('Xem trước')),
          PopupMenuItem(value: 'toggle', child: Text('Xuất bản / ẩn')),
        ],
        if (s == 'Địa danh')
          const PopupMenuItem(value: 'toggle', child: Text('Ẩn / hiển thị')),
        if (s == 'Đánh giá')
          const PopupMenuItem(value: 'toggle', child: Text('Ẩn / khôi phục')),
        if (s == 'Tài khoản' && row.id != 'user0')
          const PopupMenuItem(value: 'toggle', child: Text('Khóa / mở khóa')),
        if (canEditDelete)
          const PopupMenuItem(value: 'delete', child: Text('Xóa')),
      ],
    );
  }

  void _toggle(AdminRecord r) {
    final data = widget.data;
    switch (widget.section) {
      case 'Tài khoản':
        data.toggle(r, on: 'Hoạt động', off: 'Đã khóa');
      case 'Bài viết':
        data.toggle(r, on: 'Đã xuất bản', off: 'Đã ẩn');
      default:
        data.toggle(r, on: 'Đang hiển thị', off: 'Đã ẩn');
    }
  }

  Future<void> _confirmDelete(BuildContext context, AdminRecord row) async {
    final messenger = ScaffoldMessenger.of(context);
    if (widget.data.isLinked(widget.section, row)) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Không thể xóa vì vẫn còn địa danh đang liên kết.'),
        ),
      );
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Xóa dữ liệu?'),
        content: Text(
          'Bạn có chắc muốn xóa “${row.title}”? Thao tác này chỉ áp dụng cho dữ liệu demo trong phiên hiện tại.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (ok == true) {
      widget.data.remove(widget.section, row);
      messenger.showSnackBar(
        const SnackBar(content: Text('Đã xóa dữ liệu demo')),
      );
    }
  }

  void _preview(BuildContext context, AdminRecord r) => showDialog<void>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(r.title),
      content: SingleChildScrollView(
        child: Text(
          '${r.values['Mô tả ngắn'] ?? ''}\n\n${r.values['Nội dung'] ?? ''}',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c),
          child: const Text('Đóng'),
        ),
      ],
    ),
  );
}
