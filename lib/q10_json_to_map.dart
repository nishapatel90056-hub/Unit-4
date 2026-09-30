import 'dart:convert';
import 'package:flutter/material.dart';

/// Q10: Converts a JSON string back into a Dart Map using jsonDecode() and prints its values.
class Q10JsonToMapScreen extends StatefulWidget {
  const Q10JsonToMapScreen({super.key});

  @override
  State<Q10JsonToMapScreen> createState() => _Q10JsonToMapScreenState();
}

class _Q10JsonToMapScreenState extends State<Q10JsonToMapScreen> {
  final String _rawJsonString = '{"name": "Ananya", "age": 22, "city": "Ahmedabad", "skills": ["Flutter", "Dart"]}';
  Map<String, dynamic>? _decodedMap;

  void _convertJsonToMap() {
    // jsonDecode converts JSON string back into Dart Map
    final Map<String, dynamic> mapData = jsonDecode(_rawJsonString);
    setState(() {
      _decodedMap = mapData;
    });

    print('--- Decoded Map Values ---');
    mapData.forEach((key, value) {
      print('$key: $value');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q10: JSON to Map (jsonDecode)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Raw JSON String:', style: TextStyle(fontWeight: FontWeight.bold)),
            SelectableText(_rawJsonString),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _convertJsonToMap,
              child: const Text('Convert JSON to Map using jsonDecode()'),
            ),
            const SizedBox(height: 20),
            if (_decodedMap != null) ...[
              const Text('Decoded Map Values:', style: TextStyle(fontWeight: FontWeight.bold)),
              ..._decodedMap!.entries.map((e) => Text('${e.key} => ${e.value}')),
            ]
          ],
        ),
      ),
    );
  }
}
