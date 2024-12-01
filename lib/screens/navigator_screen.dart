import 'package:flutter/material.dart';
import 'package:jl_team_front_bit/screens/communities_screen.dart';
import 'package:jl_team_front_bit/screens/explore_hobbies_screen.dart';

import '../service/service.dart';
import 'account_screen.dart';
import 'bottom_navigation_panel.dart';

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

  @override
  void initState() {
    super.initState();
    communitiesScreen = CommunitiesScreen(service: widget.service);
    accountScreen = AccountScreen(service: widget.service);
    swipeScreen = SwipeScreen(service: widget.service);
    _pages = <Widget>[
      accountScreen,
      swipeScreen,
      communitiesScreen
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
