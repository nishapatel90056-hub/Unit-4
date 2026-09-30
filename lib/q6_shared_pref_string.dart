import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Q6: Stores a String value using SharedPreferences and retrieves it correctly.
class Q6SharedPrefStringScreen extends StatefulWidget {
  const Q6SharedPrefStringScreen({super.key});

  @override
  State<Q6SharedPrefStringScreen> createState() => _Q6SharedPrefStringScreenState();
}

class _Q6SharedPrefStringScreenState extends State<Q6SharedPrefStringScreen> {
  final TextEditingController _controller = TextEditingController();
  String _savedValue = '';

  @override
  void initState() {
    super.initState();
    _loadSavedString();
  }

  Future<void> _loadSavedString() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedValue = prefs.getString('user_string_key') ?? 'No saved value yet';
    });
  }

  Future<void> _saveString() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_string_key', _controller.text);
    await _loadSavedString();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('String saved to SharedPreferences!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q6: Shared Preferences String')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter String to Store',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveString,
              child: const Text('Save String'),
            ),
            const SizedBox(height: 24),
            Text(
              'Retrieved Value:\n$_savedValue',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
