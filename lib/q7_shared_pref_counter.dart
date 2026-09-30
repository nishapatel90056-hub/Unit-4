import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Q7: Stores an integer counter using SharedPreferences and increments it every time a button is pressed.
class Q7SharedPrefCounterScreen extends StatefulWidget {
  const Q7SharedPrefCounterScreen({super.key});

  @override
  State<Q7SharedPrefCounterScreen> createState() => _Q7SharedPrefCounterScreenState();
}

class _Q7SharedPrefCounterScreenState extends State<Q7SharedPrefCounterScreen> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt('counter_key') ?? 0;
    });
  }

  Future<void> _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter++;
    });
    await prefs.setInt('counter_key', _counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q7: Shared Pref Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Button press count (Persisted):', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('$_counter', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _incrementCounter,
              icon: const Icon(Icons.add),
              label: const Text('Increment Counter'),
            ),
          ],
        ),
      ),
    );
  }
}
