import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  double fontSize = 16.0;
  String fontFamily = 'Roboto';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Load saved settings from SharedPreferences
  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
      fontSize = prefs.getDouble('fontSize') ?? 16.0;
      fontFamily = prefs.getString('fontFamily') ?? 'Roboto';
    });
  }

  void _updateTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    setState(() {
      isDarkMode = value;
    });
  }

  void _updateFontSize(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', value);
    setState(() {
      fontSize = value;
    });
  }

  void _updateFontFamily(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fontFamily', value);
    setState(() {
      fontFamily = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Font Size Setting
          ListTile(
            leading: const Icon(Icons.text_fields),
            title: const Text('Font Size'),
            subtitle: Text('Current size: ${fontSize.toStringAsFixed(0)}'),
            trailing: DropdownButton<double>(
              value: fontSize, // Ensure this is never null
              items: [12.0, 14.0, 16.0, 18.0, 20.0, 24.0]
                  .map((size) => DropdownMenuItem(
                value: size,
                child: Text('${size.toInt()}'),
              ))
                  .toList(),
              onChanged: (newSize) {
                if (newSize != null) {
                  _updateFontSize(newSize); // Always pass a valid fontSize
                }
              },
            ),
          ),
          const Divider(),
          // Font Family Setting
          ListTile(
            leading: const Icon(Icons.font_download),
            title: const Text('Font Family'),
            subtitle: Text('Current font: $fontFamily'),
            trailing: DropdownButton<String>(
              value: fontFamily,
              items: ['Roboto', 'OpenSans', 'Lato', 'Merriweather']
                  .map((font) => DropdownMenuItem(
                value: font,
                child: Text(font),
              ))
                  .toList(),
              onChanged: (newFont) {
                if (newFont != null) {
                  _updateFontFamily(newFont);
                }
              },
            ),
          ),
          const Divider(),
          // Theme Toggle
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('Dark Mode'),
            subtitle: Text(isDarkMode ? 'Enabled' : 'Disabled'),
            trailing: Switch(
              value: isDarkMode,
              onChanged: _updateTheme,
            ),
          ),
        ],
      ),
    );
  }
}
