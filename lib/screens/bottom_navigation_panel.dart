import 'package:flutter/material.dart';

class BottomNavigationBarComponent extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const BottomNavigationBarComponent({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'My Communities',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore Hobbies',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Account',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.blue.shade600,
      unselectedItemColor: Colors.blueGrey.shade400,
      backgroundColor: Colors.white,
      onTap: onItemTapped,
    );
  }
}
