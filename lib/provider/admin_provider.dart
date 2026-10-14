import 'package:flutter/foundation.dart';

import '../data/places_data.dart';
import '../data/posts_data.dart';

class AdminRecord {
  AdminRecord(this.id, this.values);
  final String id;
  final Map<String, String> values;
  String get title =>
      values['Tên'] ?? values['Tiêu đề'] ?? values['Người dùng'] ?? '';
  String get subtitle =>
      values['Tỉnh/thành'] ?? values['Email'] ?? values['Địa danh'] ?? '';
  String get status => values['Trạng thái'] ?? 'Đang hiển thị';
}

class AdminProvider extends ChangeNotifier {
  late final Map<String, List<AdminRecord>> records = _seed();

  Map<String, List<AdminRecord>> _seed() {
    final places = samplePlaces
        .map(
          (p) => AdminRecord(p.id, {
            'Tên': p.name,
            'Tỉnh/thành': p.location,
            'Loại hình': p.category,
            'Đánh giá': p.rating.toStringAsFixed(1),
            'Địa chỉ': p.location,
            'Mô tả': p.description,
            'Ảnh': p.imageUrl,
            'Trạng thái': 'Đang hiển thị',
            'Vĩ độ': '',
            'Kinh độ': '',
          }),
        )
        .toList();

    final posts = samplePosts.asMap().entries.map((entry) {
      final p = entry.value;
      return AdminRecord(p.id, {
        'Tiêu đề': p.title,
        'Tác giả': p.author,
        'Ngày cập nhật': p.date,
        'Mô tả ngắn': p.summary,
        'Nội dung': p.content,
        'Ảnh': samplePlaces[entry.key % samplePlaces.length].imageUrl,
        'Trạng thái': p.id == '4' ? 'Bản nháp' : 'Đã xuất bản',
      });
    }).toList();

    final cities = places.map((p) => p.values['Tỉnh/thành']!).toSet().toList();
    // Lấy loại hình từ dữ liệu thật để không bị lệch với địa danh
    final categories = places
        .map((p) => p.values['Loại hình']!)
        .toSet()
        .toList();

    final result = <String, List<AdminRecord>>{
      'Địa danh': places,
      'Tỉnh/thành': cities
          .asMap()
          .entries
          .map(
            (e) => AdminRecord('city${e.key}', {
              'Tên': e.value,
              'Số địa danh': '0',
              'Mô tả': 'Điểm đến tại ${e.value}',
            }),
          )
          .toList(),
      'Loại hình': categories
          .asMap()
          .entries
          .map(
            (e) => AdminRecord('cat${e.key}', {
              'Tên': e.value,
              'Số địa danh': '0',
              'Mô tả': 'Các điểm du lịch ${e.value.toLowerCase()} nổi bật',
            }),
          )
          .toList(),
      'Bài viết': posts,
      'Đánh giá': List.generate(
        12,
        (i) => AdminRecord('review$i', {
          'Người dùng': [
            'Minh Tuấn',
            'Khánh Linh',
            'Gia Bảo',
            'Thảo Nguyên',
          ][i % 4],
          'Địa danh': places[i % places.length].title,
          'Điểm': '${(i % 3) + 3}.0',
          'Nội dung': [
            'Trải nghiệm tuyệt vời, cảnh đẹp và dịch vụ thân thiện.',
            'Thông tin hữu ích, mình sẽ quay lại lần tới.',
            'Địa điểm đẹp, cần cập nhật thêm thông tin giờ mở cửa.',
          ][i % 3],
          'Ngày gửi': '0${(i % 9) + 1}/09/2026',
          'Trạng thái': i == 2 ? 'Đã ẩn' : 'Đang hiển thị',
        }),
      ),
      'Tài khoản': List.generate(
        10,
        (i) => AdminRecord('user$i', {
          'Người dùng': ['Nguyễn An', 'Trần Bình', 'Lê Chi', 'Phạm Duy'][i % 4],
          'Email': 'thanhvien${i + 1}@example.com',
          'Vai trò': i == 0 ? 'Admin' : 'Thành viên',
          'Trạng thái': i == 3 ? 'Đã khóa' : 'Hoạt động',
          'Ngày tham gia': '0${(i % 9) + 1}/08/2026',
        }),
      ),
    };
    _refreshCounts(result);
    return result;
  }

  List<AdminRecord> of(String section) => records[section] ?? [];

  void save(String section, AdminRecord? old, Map<String, String> values) {
    final list = of(section);
    final oldName = old?.title;
    final newValues = Map<String, String>.of(values);

    if (old == null) {
      // Địa danh mới chưa có đánh giá thì mặc định 0.0
      if (section == 'Địa danh') newValues.putIfAbsent('Đánh giá', () => '0.0');
      list.insert(
        0,
        AdminRecord(
          DateTime.now().microsecondsSinceEpoch.toString(),
          newValues,
        ),
      );
    } else {
      // Giữ lại các trường không nằm trong form (vd: 'Đánh giá', 'Số địa danh')
      old.values.addAll(newValues);
    }

    final newName = newValues['Tên'];
    if (oldName != null && newName != null && oldName != newName) {
      // Đổi tên tỉnh/thành hoặc loại hình thì cập nhật các địa danh liên kết
      final linkedField = switch (section) {
        'Tỉnh/thành' => 'Tỉnh/thành',
        'Loại hình' => 'Loại hình',
        _ => null,
      };
      if (linkedField != null) {
        for (final place in of('Địa danh')) {
          if (place.values[linkedField] == oldName)
            place.values[linkedField] = newName;
        }
      }
      // Đổi tên địa danh thì cập nhật các đánh giá tham chiếu
      if (section == 'Địa danh') {
        for (final review in of('Đánh giá')) {
          if (review.values['Địa danh'] == oldName)
            review.values['Địa danh'] = newName;
        }
      }
    }

    _refreshCounts(records);
    notifyListeners();
  }

  bool isLinked(String section, AdminRecord row) {
    final field = switch (section) {
      'Tỉnh/thành' => 'Tỉnh/thành',
      'Loại hình' => 'Loại hình',
      _ => null,
    };
    return field != null &&
        of('Địa danh').any((place) => place.values[field] == row.title);
  }

  void remove(String section, AdminRecord row) {
    of(section).remove(row);
    _refreshCounts(records);
    notifyListeners();
  }

  void toggle(
    AdminRecord row, {
    String field = 'Trạng thái',
    String on = 'Đang hiển thị',
    String off = 'Đã ẩn',
  }) {
    row.values[field] = row.values[field] == on ? off : on;
    notifyListeners();
  }

  /// Cập nhật một trường và thông báo UI (thay cho việc gọi notifyListeners từ widget).
  void setField(AdminRecord row, String key, String value) {
    row.values[key] = value;
    notifyListeners();
  }

  static void _refreshCounts(Map<String, List<AdminRecord>> data) {
    final places = data['Địa danh'] ?? const <AdminRecord>[];
    for (final row in data['Tỉnh/thành'] ?? const <AdminRecord>[]) {
      row.values['Số địa danh'] =
          '${places.where((p) => p.values['Tỉnh/thành'] == row.title).length}';
    }
    for (final row in data['Loại hình'] ?? const <AdminRecord>[]) {
      row.values['Số địa danh'] =
          '${places.where((p) => p.values['Loại hình'] == row.title).length}';
    }
  }
}
