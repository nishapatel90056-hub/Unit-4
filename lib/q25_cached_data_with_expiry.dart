import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Q25: Caching system with expiry: stores timestamp and auto-refetches if > 5 minutes passed.
class Q25CachedDataWithExpiryScreen extends StatefulWidget {
  const Q25CachedDataWithExpiryScreen({super.key});

  @override
  State<Q25CachedDataWithExpiryScreen> createState() => _Q25CachedDataWithExpiryScreenState();
}

class _Q25CachedDataWithExpiryScreenState extends State<Q25CachedDataWithExpiryScreen> {
  static const int expiryMinutes = 5;
  String _data = 'No data loaded';
  String _cacheInfo = '';

  Future<void> loadDataWithExpiryCheck() async {
    final prefs = await SharedPreferences.getInstance();
    final int? lastFetchMillis = prefs.getInt('cache_timestamp');
    final String? cachedData = prefs.getString('cached_payload');

    final now = DateTime.now();
    bool isExpired = true;

    if (lastFetchMillis != null) {
      final lastFetchTime = DateTime.fromMillisecondsSinceEpoch(lastFetchMillis);
      final difference = now.difference(lastFetchTime);
      isExpired = difference.inMinutes >= expiryMinutes;
      setState(() {
        _cacheInfo = 'Last Fetch: $lastFetchTime (${difference.inSeconds}s ago). Expired: $isExpired';
      });
    }

    if (!isExpired && cachedData != null) {
      setState(() {
        _data = '$cachedData (SERVED FROM VALID LOCAL CACHE)';
      });
    } else {
      // Expired or missing -> Fetch from network API
      setState(() {
        _cacheInfo = 'Cache missing or EXPIRED (> $expiryMinutes mins). Fetching fresh data...';
      });

      final res = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        final freshData = decoded['title'].toString();

        await prefs.setString('cached_payload', freshData);
        await prefs.setInt('cache_timestamp', now.millisecondsSinceEpoch);

        setState(() {
          _data = '$freshData (FRESHLY FETCHED & CACHED)';
          _cacheInfo = 'Cache updated at: $now';
        });
      }
    }
  }

  Future<void> _simulateExpiry() async {
    final prefs = await SharedPreferences.getInstance();
    // Set timestamp to 10 minutes ago
    final tenMinsAgo = DateTime.now().subtract(const Duration(minutes: 10));
    await prefs.setInt('cache_timestamp', tenMinsAgo.millisecondsSinceEpoch);
    setState(() {
      _cacheInfo = 'Simulated cache timestamp set to 10 mins ago!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q25: Cached Data with Expiry (5 Mins)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: loadDataWithExpiryCheck,
              child: const Text('Fetch Data (Check 5-Min Expiry)'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _simulateExpiry,
              child: const Text('Simulate Expired Cache (> 5 mins)'),
            ),
            const SizedBox(height: 20),
            Text(_cacheInfo, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(_data, style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
