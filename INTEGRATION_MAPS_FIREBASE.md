# Google Maps và Firebase

Đã ghép phần cấu hình từ `do_an_uddd-main` vào dự án `do_an`.

- `lib/main.dart`: chờ `AppInitializer.initialize()` trước `runApp`, đăng ký route `/map`.
- `lib/services/app_initializer.dart`: khởi tạo Firebase trên Android; nền tảng chưa cấu hình vẫn mở được giao diện hiện có.
- `lib/firebase_options.dart`: cấu hình Firebase của nhóm (project `viet-di-app`).
- `lib/screens/map_screen.dart`: bản đồ, Routes API, đổi phương tiện, đảo điểm đi/đến, trạng thái tải và thử lại.
- `lib/config/maps_config.dart`: khóa Routes API; có thể ghi đè bằng `--dart-define=GOOGLE_MAPS_API_KEY=...`.
- `android/app/src/main/res/values/google_maps_api.xml`: khóa Maps SDK Android. Khi đổi khóa, cập nhật cả khóa native này và khóa Dart.
- `android/app/google-services.json`: cấu hình Android Firebase của thành viên.

## Chạy

```sh
flutter pub get
flutter run -d <android-device-id>
```

Trên Windows, cần bật Developer Mode nếu Flutter báo thiếu symlink support.
Đăng nhập mẫu → Khám phá → nút bản đồ “Chỉ đường” ở hàng tiêu đề.
Bản đồ giữ hai điểm mẫu: ĐH Công Thương TP.HCM và Chợ Bến Thành.
Các ô địa chỉ chỉ đọc; chưa có tìm kiếm Places hoặc lấy GPS.

## Cấu hình Android

`applicationId` dùng `com.example.viet_di_ghep` để khớp Firebase Android app đã có.
Namespace Kotlin vẫn là `com.example.do_an`; tên package Dart vẫn là `do_an`.
Nếu máy đã cài bản `com.example.do_an`, bản này sẽ là ứng dụng riêng, không nâng cấp dữ liệu bản cũ.
Muốn giữ ID cũ, đăng ký Android app `com.example.do_an` trong Firebase rồi thay cấu hình và `applicationId` tương ứng.

Google Cloud của nhóm cần bật Maps SDK for Android, Routes API và billing.
Nếu khóa Maps giới hạn ứng dụng, thêm package `com.example.viet_di_ghep` và SHA-1 của máy build.
Chưa kiểm chứng quyền truy cập, billing hoặc giới hạn khóa trên Google Cloud của nhóm.
Không bật lớp vị trí của tôi vì chưa triển khai xin quyền GPS.

## Phạm vi Firebase

Đã tích hợp khởi tạo Firebase Core. Đăng nhập, bài viết, bình luận, cộng đồng và check-in vẫn dùng luồng dữ liệu hiện có của `do_an`.
Không chép provider của bản gửi vì chúng còn xung đột Firebase/Supabase và sẽ làm mất chức năng hiện tại.
Chưa tích hợp Firebase Auth hoặc đồng bộ Firestore. Không ghi dữ liệu lên Firebase trong quá trình ghép.
Web/iOS/desktop chưa có cấu hình Firebase/Maps từ thành viên; màn hình bản đồ hiển thị thông báo trên các nền tảng đó.

Tài liệu: [Firebase Flutter setup](https://firebase.google.com/docs/flutter/setup), [Google Maps Flutter](https://pub.dev/packages/google_maps_flutter).

## Kiểm tra đã chạy

- `flutter test --no-pub`: đạt, kiểm tra màn hình đăng nhập, route bản đồ trên nền tảng chưa hỗ trợ và điều hướng quay lại.
- `flutter analyze --no-pub lib/main.dart lib/services/app_initializer.dart lib/config/maps_config.dart lib/screens/map_screen.dart lib/firebase_options.dart test/widget_test.dart`: không có vấn đề.
- Phân tích toàn dự án còn các góp ý lint trong mã có sẵn; không có lỗi Dart.
- `flutter build apk --debug --no-pub`: thành công, APK tại `build/app/outputs/flutter-apk/app-debug.apk`. Có cảnh báo tương thích Kotlin tương lai từ plugin Firebase Core.
- Chưa kiểm chứng bản đồ hoặc kết nối Firebase trên thiết bị thật.
