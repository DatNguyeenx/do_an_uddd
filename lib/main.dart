import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/comment_provider.dart';
import 'provider/post_provider.dart';
import 'provider/profile_provider.dart';
import 'screens/login_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://qetkhkdkyayyeztzqtaw.supabase.co',
    anonKey: 'sb_publishable_5ZYs5ooGUPc6bN3HAInVng_X6G7M-yp', 
  );

  runApp(const VietDiApp());

} 

/// Chỉ một MaterialApp, chỉ một bộ provider cho tất cả màn hình.
class VietDiApp extends StatelessWidget {
  const VietDiApp({super.key});
  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ProfileProvider()),
          ChangeNotifierProvider(create: (_) => PostProvider()),
          ChangeNotifierProvider(create: (_) => CommentProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Việt Đi',
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Roboto',
            scaffoldBackgroundColor: const Color(0xFFF8FAFC),
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
          ),
          initialRoute: '/login',
          routes: {
            '/login': (_) => const LoginScreen(),
            '/home': (_) => const MainNavigationScreen(),
          },
        ),
      );
}
