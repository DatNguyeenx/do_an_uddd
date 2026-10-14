import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:viet_di_ghep/main.dart';

void main() {
  testWidgets('Login and map route remain accessible', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    expect(find.text('Chào mừng trở lại'), findsOneWidget);

    final context = tester.element(find.text('Chào mừng trở lại'));
    Navigator.of(context).pushNamed('/map');
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Bản đồ hiện được cấu hình cho Android'),
      findsOneWidget,
    );
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Chào mừng trở lại'), findsOneWidget);
  }, variant: TargetPlatformVariant.only(TargetPlatform.linux));
}
