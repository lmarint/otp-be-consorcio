
import 'package:flutter/material.dart';
import 'modules/login/view/login_page.dart';
import 'otp_view.dart';
import 'modules/login/service/session_storage.dart';
import 'splash_screen.dart';
import 'theme/consorcio_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final token = await SessionStorage.getToken();
  runApp(MyApp(initialRoute: token != null && token.isNotEmpty ? '/otp' : '/login'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consorcio',
      theme: ConsorcioTheme.light(),
      routes: {
        '/splash': (_) => SplashScreen(nextRoute: initialRoute),
        '/login': (_) => const LoginPage(),
        '/otp': (_) => const OTPView(),
      },
      initialRoute: '/splash', // ✅ Splash primero
    );
  }
}
