import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final bool isDarkMode;
  final double fontSize;
  final ValueChanged<bool> onThemeChanged;
  final ValueChanged<double> onFontSizeChanged;

  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.fontSize,
    required this.onThemeChanged,
    required this.onFontSizeChanged,
  });

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
                  onFontSizeChanged(newSize); // Always pass a valid fontSize
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
              onChanged: onThemeChanged, // Call the callback to toggle theme
            ),
          ),
        ],
      ),
    );
  }
}
