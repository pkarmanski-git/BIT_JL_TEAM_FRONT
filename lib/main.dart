import 'package:flutter/material.dart';
import 'package:jl_team_front_bit/screens/AboutMeScreen.dart';
import 'package:jl_team_front_bit/screens/LoginScreen.dart';
import 'package:jl_team_front_bit/screens/RegisterScreen.dart';
import 'package:jl_team_front_bit/screens/WelcomeScreen.dart';
import 'package:jl_team_front_bit/service/service.dart';
import 'screens/SplashScreen.dart';
import 'constants/colors.dart';
import 'screens/SwipeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Service service = Service();

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
        '/splash': (context) => SplashScreen(service: service),
        '/welcome': (context) => WelcomeScreen(service: service),
        '/login': (context) => LoginScreen(service: service),
        '/register': (context) => RegisterScreen(service: service),
        '/aboutme': (context) => AboutMeScreen(service: service),
          '/swipe': (context) => const SwipeScreen(),
        },
    );
  }
}
