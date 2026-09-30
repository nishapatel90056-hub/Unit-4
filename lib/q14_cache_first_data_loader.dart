import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Q14: Cache-first data loader that checks a memory cache before calling a network API using http package.
class Q14CacheFirstDataLoaderScreen extends StatefulWidget {
  const Q14CacheFirstDataLoaderScreen({super.key});

  @override
  State<Q14CacheFirstDataLoaderScreen> createState() => _Q14CacheFirstDataLoaderScreenState();
}

class _Q14CacheFirstDataLoaderScreenState extends State<Q14CacheFirstDataLoaderScreen> {
  final Map<String, String> _memoryCache = {};
  String _data = 'No data loaded';
  String _source = '';

  Future<void> loadData(String url) async {
    // 1. Check memory cache first
    if (_memoryCache.containsKey(url)) {
      setState(() {
        _data = _memoryCache[url]!;
        _source = 'Loaded instantly from MEMORY CACHE';
      });
      return;
    }

    // 2. Fallback to network API if not in cache
    setState(() {
      _source = 'Fetching from Network API...';
    });

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final title = decoded['title'] ?? response.body;

        // Store in memory cache
        _memoryCache[url] = title;

        setState(() {
          _data = title;
          _source = 'Loaded from NETWORK API and saved into cache';
        });
      } else {
        setState(() {
          _source = 'HTTP Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _source = 'Network Exception: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const testUrl = 'https://jsonplaceholder.typicode.com/todos/1';

    return Scaffold(
      appBar: AppBar(title: const Text('Q14: Cache-First Data Loader')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => loadData(testUrl),
              child: const Text('Load Data (Cache-First)'),
            ),
            const SizedBox(height: 20),
            Text(_source, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 12),
            Text(_data, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
