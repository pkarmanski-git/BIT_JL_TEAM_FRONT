import 'package:flutter/material.dart';

import 'bottom_navigation_panel.dart';

class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({super.key});

  @override
  _NavigatorState createState() => _NavigatorState();
}

class _NavigatorState extends State<NavigatorScreen> {
  int _selectedIndex = 0;
  // late QuizGeneratorScreen quizGeneratorScreen;
  // late HistoryScreen historyScreen;
  // late AuthScreen authScreen;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // quizGeneratorScreen = QuizGeneratorScreen(mainController: widget.mainController);
    // historyScreen = HistoryScreen(mainController: widget.mainController);
    // authScreen = AuthScreen(mainController: widget.mainController);
    _pages = <Widget>[
      // quizGeneratorScreen,
      // historyScreen,
      // authScreen
    ];
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBarComponent(
        selectedIndex: _selectedIndex,
        onItemTapped: onItemTapped,
      ),
    );
  }
}
