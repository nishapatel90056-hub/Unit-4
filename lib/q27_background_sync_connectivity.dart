import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Q27: Background sync mechanism that pushes offline records when connectivity_plus reports online.
class Q27BackgroundSyncConnectivityScreen extends StatefulWidget {
  const Q27BackgroundSyncConnectivityScreen({super.key});

  @override
  State<Q27BackgroundSyncConnectivityScreen> createState() => _Q27BackgroundSyncConnectivityScreenState();
}

class _Q27BackgroundSyncConnectivityScreenState extends State<Q27BackgroundSyncConnectivityScreen> {
  StreamSubscription? _connectivitySubscription;
  bool _isOnline = false;
  List<Map<String, dynamic>> _offlineRecords = [];
  String _syncLog = 'Listening for network changes...';

  @override
  void initState() {
    super.initState();
    _loadOfflineRecords();
    _initConnectivityListener();
  }

  Future<void> _loadOfflineRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('offline_sync_records') ?? '[]';
    final List<dynamic> list = jsonDecode(jsonStr);
    setState(() {
      _offlineRecords = List<Map<String, dynamic>>.from(list);
    });
  }

  Future<void> _saveOfflineRecords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('offline_sync_records', jsonEncode(_offlineRecords));
  }

  void _initConnectivityListener() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final isConnected = results.any((r) => r != ConnectivityResult.none);
      setState(() {
        _isOnline = isConnected;
      });

      if (isConnected) {
        _triggerBackgroundSync();
      }
    });
  }

  Future<void> _triggerBackgroundSync() async {
    if (_offlineRecords.isEmpty) return;

    setState(() {
      _syncLog = 'Online detected! Syncing ${_offlineRecords.length} records to server...';
    });

    // Simulate pushing records to remote backend
    await Future.delayed(const Duration(seconds: 2));

    int count = _offlineRecords.length;
    _offlineRecords.clear();
    await _saveOfflineRecords();

    setState(() {
      _syncLog = 'BACKGROUND SYNC COMPLETE! Successfully synced $count records at ${DateTime.now().second}s.';
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Auto Sync: $count records synced to server!')),
      );
    }
  }

  Future<void> _addOfflineRecord() async {
    final record = {
      'title': 'Record #${_offlineRecords.length + 1}',
      'timestamp': DateTime.now().toIso8601String(),
    };
    _offlineRecords.add(record);
    await _saveOfflineRecords();
    setState(() {});

    if (_isOnline) {
      _triggerBackgroundSync();
    }
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q27: Background Sync Connectivity')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              color: _isOnline ? Colors.green.shade100 : Colors.red.shade100,
              child: Row(
                children: [
                  Icon(_isOnline ? Icons.signal_cellular_4_bar : Icons.signal_cellular_off, color: _isOnline ? Colors.green : Colors.red),
                  const SizedBox(width: 10),
                  Text(_isOnline ? 'Online: Auto Sync Active' : 'Offline: Saving locally for sync'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addOfflineRecord,
              child: const Text('Create New Local Record'),
            ),
            const SizedBox(height: 16),
            Text(_syncLog, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 16),
            const Text('Pending Records To Sync:'),
            Expanded(
              child: ListView.builder(
                itemCount: _offlineRecords.length,
                itemBuilder: (ctx, idx) => ListTile(
                  leading: const Icon(Icons.sync_problem, color: Colors.orange),
                  title: Text(_offlineRecords[idx]['title']),
                  subtitle: Text(_offlineRecords[idx]['timestamp']),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
