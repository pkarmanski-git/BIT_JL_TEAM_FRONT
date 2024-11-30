import 'package:flutter/material.dart';
import 'package:jl_team_front_bit/service/service.dart';
import 'screens/SplashScreen.dart';
import 'constants/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final service = Service();
  await service.init();

  runApp(MyApp(service: service));
}

class MyApp extends StatelessWidget {
  final Service service;

  const MyApp({Key? key, required this.service}) : super(key: key);
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
      home: SplashScreen(service: service),
    );
  }
}
