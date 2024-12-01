import 'package:flutter/material.dart';
import 'package:jl_team_front_bit/screens/navigator_screen.dart';
import 'package:jl_team_front_bit/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/colors.dart';
import 'service/service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final service = Service();
  await service.init();

  runApp(MyApp(service: service));
}

class MyApp extends StatefulWidget {
  final Service service;

  const MyApp({Key? key, required this.service}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  double _fontSize = 16.0;
  String _fontFamily = 'Roboto';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _fontSize = prefs.getDouble('fontSize') ?? 16.0;
      _fontFamily = prefs.getString('fontFamily') ?? 'Roboto';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hobby Finder',
      theme: _isDarkMode
          ? ThemeData.dark().copyWith(
        textTheme: ThemeData.dark().textTheme.copyWith(
          bodyLarge: TextStyle(
            fontSize: _fontSize,
            fontFamily: _fontFamily,
            color: AppColors.textColor,
          ),
          bodyMedium: TextStyle(
            fontSize: _fontSize,
            fontFamily: _fontFamily,
            color: AppColors.textColor,
          ),
          bodySmall: TextStyle(
            fontSize: _fontSize,
            fontFamily: _fontFamily,
            color: AppColors.textColor,
          ),
        ),
      )
          : ThemeData.light().copyWith(
        primaryColor: AppColors.primaryColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: AppColors.secondaryColor,
        ),
        scaffoldBackgroundColor: AppColors.backgroundColor,
        textTheme: ThemeData.light().textTheme.copyWith(
          bodyLarge: TextStyle(
            fontSize: _fontSize,
            fontFamily: _fontFamily,
            color: AppColors.textColor,
          ),
          bodyMedium: TextStyle(
            fontSize: _fontSize,
            fontFamily: _fontFamily,
            color: AppColors.textColor,
          ),
          bodySmall: TextStyle(
            fontSize: _fontSize,
            fontFamily: _fontFamily,
            color: AppColors.textColor,
          ),
        ),
      ),
      home: widget.service.user.isLogged ? NavigatorScreen(service: widget.service): WelcomeScreen(service: widget.service),
    );
  }
}
