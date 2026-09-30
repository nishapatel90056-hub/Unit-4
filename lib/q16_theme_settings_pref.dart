import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Q16: Settings screen that saves a theme preference (dark/light) using SharedPreferences and applies it.
class Q16ThemeSettingsPrefScreen extends StatefulWidget {
  const Q16ThemeSettingsPrefScreen({super.key});

  @override
  State<Q16ThemeSettingsPrefScreen> createState() => _Q16ThemeSettingsPrefScreenState();
}

class _Q16ThemeSettingsPrefScreenState extends State<Q16ThemeSettingsPrefScreen> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('is_dark_mode') ?? false;
    });
  }

  Future<void> _toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', value);
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeDataWrapper(
      isDarkMode: _isDarkMode,
      child: Scaffold(
        appBar: AppBar(title: const Text('Q16: Theme Preference Settings')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Dark Theme'),
                subtitle: const Text('Saved preference persists across app launches'),
                value: _isDarkMode,
                onChanged: _toggleTheme,
              ),
              const SizedBox(height: 30),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Current Selected Theme: ${_isDarkMode ? "DARK" : "LIGHT"}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThemeDataWrapper extends StatelessWidget {
  final bool isDarkMode;
  final Widget child;

  const ThemeDataWrapper({super.key, required this.isDarkMode, required this.child});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: child,
    );
  }
}
