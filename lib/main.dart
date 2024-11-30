import 'package:flutter/material.dart';
import 'screens/SplashScreen.dart';
import 'screens/WelcomeScreen.dart';
import 'screens/LoginScreen.dart';
import 'screens/RegisterScreen.dart';
import 'screens/AboutMeScreen.dart';
import 'constants/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hobby Finder',
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: AppColors.secondaryColor,
        ),
        scaffoldBackgroundColor: AppColors.backgroundColor,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: AppColors.textColor),
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/aboutme': (context) => const AboutMeScreen(),
      },
    );
  }
}
