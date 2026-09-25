import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'screens/login_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finals Lab Act 1',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login:(context) => const LoginScreen(),
        //AppRoutes.signup:(context) => const LoginScreen(),
        //AppRoutes.home:(context) => const LoginScreen(),
      }
    );
  }
}

