import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screen.dart';
import 'constants/colors.dart';
import 'screens/settings_screen.dart';
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
    });
  }

  void _updateTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
    setState(() {
      _isDarkMode = isDarkMode;
    });
  }

  void _updateFontSize(double fontSize) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', fontSize);
    setState(() {
      _fontSize = fontSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hobby Finder',
      theme: _isDarkMode
          ? ThemeData.dark().copyWith(
        textTheme: ThemeData.dark().textTheme.copyWith(
          bodyLarge: TextStyle(
            fontSize: _fontSize,
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
            color: AppColors.textColor,
          ),
        ),
      ),
      home: SplashScreen(service: widget.service),
      routes: {
        '/settings': (context) => SettingsScreen(
          isDarkMode: _isDarkMode,
          fontSize: _fontSize,
          onThemeChanged: _updateTheme,
          onFontSizeChanged: _updateFontSize,
        ),
      },
    );
  }
}
