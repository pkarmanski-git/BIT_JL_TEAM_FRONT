import 'package:flutter/material.dart';
import 'package:jl_team_front_bit/enums/service_errors.dart';
import 'package:jl_team_front_bit/model/service_response.dart';
import 'package:jl_team_front_bit/screens/settings_screen.dart';
import 'package:jl_team_front_bit/screens/welcome_screen.dart';
import '../service/service.dart';
import 'chart_screen.dart';
import 'my_hobbies_screen.dart';

class AccountScreen extends StatefulWidget {
  final Service service;
  final bool isDarkMode;
  final double fontSize;
  final String fontFamily;
  final ValueChanged<bool> onThemeChanged;
  final ValueChanged<double> onFontSizeChanged;
  final ValueChanged<String> onFontFamilyChanged;

  const AccountScreen({
    super.key,
    required this.service,
    required this.isDarkMode,
    required this.fontSize,
    required this.fontFamily,
    required this.onThemeChanged,
    required this.onFontSizeChanged,
    required this.onFontFamilyChanged,
  });

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    // Apply font size and font family
    final TextStyle textStyle = TextStyle(
      fontSize: widget.fontSize,
      fontFamily: widget.fontFamily,
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Account',
              style: textStyle.copyWith(
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
                  _buildProfileDropdown(context, textStyle),
                  _buildSettingsCard(
                    icon: Icons.settings,
                    title: 'Settings',
                    textStyle: textStyle,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsScreen(
                            isDarkMode: widget.isDarkMode,
                            fontSize: widget.fontSize,
                            fontFamily: widget.fontFamily,
                            onThemeChanged: widget.onThemeChanged,
                            onFontSizeChanged: widget.onFontSizeChanged,
                            onFontFamilyChanged: widget.onFontFamilyChanged,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildSettingsCard(
                    icon: Icons.logout,
                    title: 'Logout',
                    iconColor: Colors.redAccent,
                    textStyle: textStyle,
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

  Widget _buildProfileDropdown(BuildContext context, TextStyle textStyle) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        leading: const Icon(Icons.person, color: Colors.blueAccent),
        title: Text(
          'My Profile',
          style: textStyle.copyWith(fontWeight: FontWeight.w500),
        ),
        children: [
          ListTile(
            title: Text('Hobbies', style: textStyle),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHobbiesScreen(service: widget.service),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Chart', style: textStyle),
            onTap: () {
              if (widget.service.user.profile != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RadarChartWidget(
                      personalityData: widget.service.user.profile!.character,
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
    required TextStyle textStyle,
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
          style: textStyle.copyWith(fontWeight: FontWeight.w500),
        ),
        onTap: onTap,
      ),
    );
  }

  void _logout(BuildContext context) async {
    try {
      ServiceResponse response = await widget.service.logout();
      if (response.error == ServiceErrors.ok) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WelcomeScreen(service: widget.service),
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
