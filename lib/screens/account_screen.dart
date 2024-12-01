import 'package:flutter/material.dart';
import 'package:jl_team_front_bit/enums/service_errors.dart';
import 'package:jl_team_front_bit/model/service_response.dart';
import 'package:jl_team_front_bit/screens/welcome_screen.dart';
import '../service/service.dart';
import 'chart_screen.dart';
import 'my_hobbies_screen.dart';

class AccountScreen extends StatelessWidget {
  final Service service;

  const AccountScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.settings,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text(
              'Account',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.greenAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 4,
        toolbarHeight: 70,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildProfileDropdown(context),
                  _buildSettingsCard(
                    icon: Icons.settings,
                    title: 'Settings',
                    onTap: () {
                      // Navigate to the settings screen using the named route
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                  _buildSettingsCard(
                    icon: Icons.logout,
                    title: 'Logout',
                    iconColor: Colors.redAccent,
                    onTap: () => _logout(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDropdown(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        leading: const Icon(Icons.person, color: Colors.blueAccent),
        title: const Text(
          'My Profile',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        children: [
          ListTile(
            title: const Text('Hobbies'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHobbiesScreen(service: service),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Chart'),
            onTap: () {
              if (service.user.profile != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RadarChartWidget(
                      personalityData: service.user.profile!.character,
                    ),
                  ),
                );
              } else {
                _showErrorSnackBar(context, 'Profile data is missing.');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor ?? Colors.blueAccent,
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        onTap: onTap,
      ),
    );
  }

  void _logout(BuildContext context) async {
    try {
      ServiceResponse response = await service.logout();
      if (response.error == ServiceErrors.ok) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WelcomeScreen(service: service),
          ),
        );
      } else {
        _showErrorDialog(context, 'Logout failed: ${response.error}');
      }
    } catch (e) {
      _showErrorDialog(context, 'An unexpected error occurred: $e');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}



class MyHobbiesScreen extends StatelessWidget {
  final Service service;
  const MyHobbiesScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.palette,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text(
              'Hobbies',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.greenAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 4,
        toolbarHeight: 70,
      ),
      body: const Center(
        child: Text(
          'Your hobbies will be displayed here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
