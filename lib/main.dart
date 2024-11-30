import 'package:flutter/material.dart';
import 'package:jl_team_front_bit/service/service.dart';
import 'screens/SplashScreen.dart';
import 'constants/colors.dart';

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
      home: SplashScreen(service: service),
    );
  }
}
