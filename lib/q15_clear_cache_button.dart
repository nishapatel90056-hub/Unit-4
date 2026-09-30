import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Q15: Implements a "Clear Cache" button that empties a cache Map and forces the next request to fetch fresh data.
class Q15ClearCacheButtonScreen extends StatefulWidget {
  const Q15ClearCacheButtonScreen({super.key});

  @override
  State<Q15ClearCacheButtonScreen> createState() => _Q15ClearCacheButtonScreenState();
}

class _Q15ClearCacheButtonScreenState extends State<Q15ClearCacheButtonScreen> {
  final Map<String, String> _cacheMap = {};
  String _status = 'Cache is currently empty.';
  String _responseContent = '';

  Future<void> _fetchData() async {
    const url = 'https://jsonplaceholder.typicode.com/posts/1';
    if (_cacheMap.containsKey(url)) {
      setState(() {
        _status = 'SERVED FROM CACHE (Cache size: ${_cacheMap.length})';
        _responseContent = _cacheMap[url]!;
      });
    } else {
      setState(() {
        _status = 'FETCHING FRESH DATA FROM NETWORK...';
      });
      final res = await http.get(Uri.parse(url));
      final decoded = jsonDecode(res.body);
      final bodyText = decoded['title'] ?? 'Sample Title';
      _cacheMap[url] = '$bodyText (Fetched at ${DateTime.now().second}s)';
      setState(() {
        _status = 'FETCHED FROM NETWORK & STORED IN CACHE';
        _responseContent = _cacheMap[url]!;
      });
    }
  }

  void _clearCache() {
    _cacheMap.clear();
    setState(() {
      _status = 'CACHE CLEARED! Next request will hit network.';
      _responseContent = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q15: Clear Cache Button')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _fetchData,
              child: const Text('Fetch Data'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade100),
              onPressed: _clearCache,
              icon: const Icon(Icons.cleaning_services, color: Colors.orange),
              label: const Text('Clear Cache', style: TextStyle(color: Colors.orange)),
            ),
            const SizedBox(height: 20),
            Text(_status, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(_responseContent),
          ],
        ),
      ),
    );
  }
}
