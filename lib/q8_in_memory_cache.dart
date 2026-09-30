import 'package:flutter/material.dart';

/// Q8: Simple in-memory cache using a Map to store and reuse API response data.
class Q8InMemoryCacheScreen extends StatefulWidget {
  const Q8InMemoryCacheScreen({super.key});

  @override
  State<Q8InMemoryCacheScreen> createState() => _Q8InMemoryCacheScreenState();
}

class _Q8InMemoryCacheScreenState extends State<Q8InMemoryCacheScreen> {
  // In-memory cache Map
  final Map<String, String> _apiCache = {};
  String _displayText = 'Tap to fetch data';
  String _sourceText = '';

  Future<void> _fetchData(String key) async {
    if (_apiCache.containsKey(key)) {
      setState(() {
        _displayText = _apiCache[key]!;
        _sourceText = 'Loaded from IN-MEMORY CACHE (No Network Delay)';
      });
    } else {
      setState(() {
        _displayText = 'Fetching from simulated network...';
        _sourceText = 'Simulating API call...';
      });

      // Simulate network request delay
      await Future.delayed(const Duration(seconds: 2));
      final responseData = 'Data for $key fetched at ${DateTime.now().toIso8601String()}';

      // Store in memory cache Map
      _apiCache[key] = responseData;

      setState(() {
        _displayText = responseData;
        _sourceText = 'Loaded from NETWORK and cached into Map!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q8: In-Memory Map Cache')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => _fetchData('user_1'),
                  child: const Text('Fetch User 1 Data'),
                ),
                ElevatedButton(
                  onPressed: () => _fetchData('user_2'),
                  child: const Text('Fetch User 2 Data'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(_sourceText, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 10),
            Text(_displayText, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
