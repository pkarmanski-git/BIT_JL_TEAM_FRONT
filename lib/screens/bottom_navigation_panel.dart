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
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(Icons.person, size: 28), // Większa ikona
          label: 'Account',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.explore, size: 28), // Większa ikona
          label: 'Explore Hobbies',
        ),
        BottomNavigationBarItem(
          icon: Stack(
            clipBehavior: Clip.none, // Pozwala wyświetlić widget poza limitem
            children: [
              Icon(Icons.people, size: 28), // Większa ikona
              Positioned(
                top: -15, // Większe przesunięcie w górę
                right: -25, // Większe przesunięcie w prawo
                child: Transform.rotate(
                  angle: 0.4, // Kąt obrotu +23 stopnie
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Większy padding
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Soon",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12, // Większa czcionka
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          label: 'My Communities',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: selectedIndex == 0 ? Colors.teal : Colors.greenAccent,
      unselectedItemColor: Colors.blueGrey.shade400,
      backgroundColor: Colors.white,
      onTap: onItemTapped,
    );
  }


}
