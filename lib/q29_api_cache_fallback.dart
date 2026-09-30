import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/// Q29: Downloads JSON from public API, saves local cached copy, and falls back to cached copy if network fails.
class Q29ApiCacheFallbackScreen extends StatefulWidget {
  const Q29ApiCacheFallbackScreen({super.key});

  @override
  State<Q29ApiCacheFallbackScreen> createState() => _Q29ApiCacheFallbackScreenState();
}

class _Q29ApiCacheFallbackScreenState extends State<Q29ApiCacheFallbackScreen> {
  String _dataStatus = 'Press button to load API data';
  String _content = '';

  Future<File> _getCacheFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/api_cached_backup.json');
  }

  Future<void> _fetchWithFallback({bool simulateError = false}) async {
    final cacheFile = await _getCacheFile();

    setState(() {
      _dataStatus = simulateError ? 'Simulating network failure...' : 'Attempting network API request...';
    });

    if (!simulateError) {
      try {
        final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
        if (response.statusCode == 200) {
          // Save a local cached copy to file
          await cacheFile.writeAsString(response.body);

          final decoded = jsonDecode(response.body);
          setState(() {
            _dataStatus = 'SUCCESS: Loaded from Live Network API & Saved to Cache File';
            _content = decoded['title'];
          });
          return;
        }
      } catch (e) {
        // Network error caught -> Fall through to cached copy fallback
      }
    }

    // FALLBACK TO LOCAL CACHED COPY
    if (await cacheFile.exists()) {
      final cachedJsonString = await cacheFile.readAsString();
      final decoded = jsonDecode(cachedJsonString);
      setState(() {
        _dataStatus = 'NETWORK FAILED -> FALLBACK: Successfully restored from Local Cached Copy File!';
        _content = decoded['title'] ?? cachedJsonString;
      });
    } else {
      setState(() {
        _dataStatus = 'NETWORK FAILED & No Cached Backup File exists yet!';
        _content = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q29: API Cache Fallback')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _fetchWithFallback(simulateError: false),
              child: const Text('Fetch Live Network API'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade100),
              onPressed: () => _fetchWithFallback(simulateError: true),
              icon: const Icon(Icons.signal_cellular_connected_no_internet_4_bar, color: Colors.deepOrange),
              label: const Text('Simulate Network Error (Trigger Fallback)', style: TextStyle(color: Colors.deepOrange)),
            ),
            const SizedBox(height: 20),
            Text(_dataStatus, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(_content.isEmpty ? '(Data display area)' : _content, style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
