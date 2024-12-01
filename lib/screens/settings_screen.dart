import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final bool isDarkMode;
  final double fontSize;
  final String fontFamily;
  final ValueChanged<bool> onThemeChanged;
  final ValueChanged<double> onFontSizeChanged;
  final ValueChanged<String> onFontFamilyChanged;

  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.fontSize,
    required this.fontFamily,
    required this.onThemeChanged,
    required this.onFontSizeChanged,
    required this.onFontFamilyChanged,
  });

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool isDarkMode;
  late double fontSize;
  late String fontFamily;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
    fontSize = widget.fontSize;
    fontFamily = widget.fontFamily;
  }

  void _updateTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
    widget.onThemeChanged(value);
  }

  void _updateFontSize(double value) {
    setState(() {
      fontSize = value;
    });
    widget.onFontSizeChanged(value);
  }

  void _updateFontFamily(String value) {
    setState(() {
      fontFamily = value;
    });
    widget.onFontFamilyChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    // Apply font size and font family
    final TextStyle textStyle = TextStyle(
      fontSize: fontSize,
      fontFamily: fontFamily,
    );

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
            title: Text('Font Size', style: textStyle),
            subtitle: Text('Current size: ${fontSize.toStringAsFixed(0)}', style: textStyle),
            trailing: DropdownButton<double>(
              value: fontSize,
              items: [12.0, 14.0, 16.0, 18.0, 20.0, 24.0]
                  .map((size) => DropdownMenuItem(
                value: size,
                child: Text('${size.toInt()}', style: textStyle),
              ))
                  .toList(),
              onChanged: (newSize) {
                if (newSize != null) {
                  _updateFontSize(newSize);
                }
              },
            ),
          ),
          const Divider(),
          // Font Family Setting
          ListTile(
            leading: const Icon(Icons.font_download),
            title: Text('Font Family', style: textStyle),
            subtitle: Text('Current font: $fontFamily', style: textStyle),
            trailing: DropdownButton<String>(
              value: fontFamily,
              items: ['Roboto', 'OpenSans', 'Lato', 'Merriweather']
                  .map((font) => DropdownMenuItem(
                value: font,
                child: Text(font, style: textStyle),
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
          // Dark Mode Setting
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: Text('Dark Mode', style: textStyle),
            subtitle: Text(isDarkMode ? 'Enabled' : 'Disabled', style: textStyle),
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
