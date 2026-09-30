import 'dart:convert';
import 'package:flutter/material.dart';

/// Q9: Converts a simple Dart Map into a JSON string using jsonEncode().
class Q9MapToJsonScreen extends StatefulWidget {
  const Q9MapToJsonScreen({super.key});

  @override
  State<Q9MapToJsonScreen> createState() => _Q9MapToJsonScreenState();
}

class _Q9MapToJsonScreenState extends State<Q9MapToJsonScreen> {
  final Map<String, dynamic> _sampleMap = {
    'name': 'Rahul Patel',
    'age': 21,
    'course': 'Computer Science',
    'isEnrolled': true,
  };

  String _jsonOutput = '';

  void _convertMapToJson() {
    // jsonEncode converts Dart Map to JSON string
    final jsonString = jsonEncode(_sampleMap);
    setState(() {
      _jsonOutput = jsonString;
    });
    print('Encoded JSON string: $jsonString');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q9: Map to JSON (jsonEncode)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Original Dart Map:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_sampleMap.toString()),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _convertMapToJson,
              child: const Text('Convert Map to JSON using jsonEncode()'),
            ),
            const SizedBox(height: 20),
            const Text('Encoded JSON String:', style: TextStyle(fontWeight: FontWeight.bold)),
            SelectableText(_jsonOutput, style: const TextStyle(color: Colors.green, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
