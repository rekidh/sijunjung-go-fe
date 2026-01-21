import 'package:flutter/material.dart';
import 'package:shared/widgets/splash_screen.dart';
import 'package:shared/theme/app_theme.dart';
import 'screens/home.dart';
import 'screens/auth/login.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sijunjung Go',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(
        homeScreen: HomeScreen(),
        loginScreen: LoginScreen(),
      ),
    );
  }
}
