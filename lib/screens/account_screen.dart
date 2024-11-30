import 'package:flutter/material.dart';
import 'package:jl_team_front_bit/enums/service_errors.dart';
import 'package:jl_team_front_bit/model/service_response.dart';
import 'package:jl_team_front_bit/screens/welcome_screen.dart';
import '../service/service.dart';

class AccountScreen extends StatelessWidget {
  final Service service;

  const AccountScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildProfileDropdown(context),
                  _buildSettingsCard(
                    icon: Icons.settings,
                    title: 'Preferences',
                    onTap: () {
                      // Navigate to Preferences (implement if needed)
                    },
                  ),
                  _buildSettingsCard(
                    icon: Icons.logout,
                    title: 'Logout',
                    iconColor: Colors.redAccent,
                    onTap: () {
                      _logout(context);
                    },
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
            title: const Text('My Hobbies'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHobbiesScreen(service: service),
                ),
              );
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
        // Navigate to WelcomeScreen on successful logout
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WelcomeScreen(service: service),
          ),
        );
      } else {
        // Handle different service error cases
        String errorMessage;
        switch (response.error) {
          case ServiceErrors.networkError:
            errorMessage = 'Network error occurred. Please try again later.';
            break;
          case ServiceErrors.unauthorized:
            errorMessage = 'Unauthorized access. Please log in again.';
            break;
          case ServiceErrors.serverError:
            errorMessage = 'Server error. Please contact support.';
            break;
          default:
            errorMessage = 'An unknown error occurred. Please try again.';
        }

        _showErrorDialog(context, errorMessage);
      }
    } catch (e) {
      // Handle unexpected errors
      _showErrorDialog(context, 'An unexpected error occurred. Please try again.');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout Failed'),
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
        behavior: SnackBarBehavior.floating,
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
        title: const Text('My Hobbies'),
        backgroundColor: Colors.blueAccent,
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
