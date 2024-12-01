import 'package:flutter/material.dart';
import 'package:jl_team_front_bit/screens/communities_screen.dart';
import 'package:jl_team_front_bit/screens/explore_hobbies_screen.dart';
import 'package:jl_team_front_bit/screens/account_screen.dart';
import 'package:jl_team_front_bit/screens/bottom_navigation_panel.dart';
import '../service/service.dart';

class NavigatorScreen extends StatefulWidget {
  final Service service;

  const NavigatorScreen({super.key, required this.service});

  @override
  _NavigatorState createState() => _NavigatorState();
}

class _NavigatorState extends State<NavigatorScreen> {
  int _selectedIndex = 0;
  late AccountScreen accountScreen;
  late SwipeScreen swipeScreen;
  late CommunitiesScreen communitiesScreen;

  late List<Widget> _pages;

  // Settings state variables
  bool isDarkMode = false;
  double fontSize = 14.0;
  String fontFamily = 'Roboto';

  @override
  void initState() {
    super.initState();

    // Initialize screens with settings
    accountScreen = AccountScreen(
      service: widget.service,
      isDarkMode: isDarkMode,
      fontSize: fontSize,
      fontFamily: fontFamily,
      onThemeChanged: _updateTheme,
      onFontSizeChanged: _updateFontSize,
      onFontFamilyChanged: _updateFontFamily,
    );

    swipeScreen = SwipeScreen(service: widget.service);
    communitiesScreen = CommunitiesScreen(service: widget.service);

    _pages = <Widget>[
      accountScreen,
      swipeScreen,
      communitiesScreen,
    ];
  }

  // Define the settings update methods
  void _updateTheme(bool value) {
    setState(() {
      isDarkMode = value;
      // Update AccountScreen with new settings
      accountScreen = AccountScreen(
        service: widget.service,
        isDarkMode: isDarkMode,
        fontSize: fontSize,
        fontFamily: fontFamily,
        onThemeChanged: _updateTheme,
        onFontSizeChanged: _updateFontSize,
        onFontFamilyChanged: _updateFontFamily,
      );
      _pages[0] = accountScreen;
    });
  }

  void _updateFontSize(double value) {
    setState(() {
      fontSize = value;
      // Update AccountScreen with new settings
      accountScreen = AccountScreen(
        service: widget.service,
        isDarkMode: isDarkMode,
        fontSize: fontSize,
        fontFamily: fontFamily,
        onThemeChanged: _updateTheme,
        onFontSizeChanged: _updateFontSize,
        onFontFamilyChanged: _updateFontFamily,
      );
      _pages[0] = accountScreen;
    });
  }

  void _updateFontFamily(String value) {
    setState(() {
      fontFamily = value;
      // Update AccountScreen with new settings
      accountScreen = AccountScreen(
        service: widget.service,
        isDarkMode: isDarkMode,
        fontSize: fontSize,
        fontFamily: fontFamily,
        onThemeChanged: _updateTheme,
        onFontSizeChanged: _updateFontSize,
        onFontFamilyChanged: _updateFontFamily,
      );
      _pages[0] = accountScreen;
    });
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Apply the selected theme
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBarComponent(
          selectedIndex: _selectedIndex,
          onItemTapped: onItemTapped,
        ),
      ),
    );
  }
}
