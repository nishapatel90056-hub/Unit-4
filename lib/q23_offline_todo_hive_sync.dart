import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Q23: Offline-first To-Do app where tasks are saved locally with Hive and synced when connectivity_plus reports online.
class Q23OfflineTodoHiveSyncScreen extends StatefulWidget {
  const Q23OfflineTodoHiveSyncScreen({super.key});

  @override
  State<Q23OfflineTodoHiveSyncScreen> createState() => _Q23OfflineTodoHiveSyncScreenState();
}

class _Q23OfflineTodoHiveSyncScreenState extends State<Q23OfflineTodoHiveSyncScreen> {
  late Box _todoBox;
  bool _isHiveInitialized = false;
  bool _isOnline = true;
  StreamSubscription? _connectivitySubscription;
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initHiveAndConnectivity();
  }

  Future<void> _initHiveAndConnectivity() async {
    await Hive.initFlutter();
    _todoBox = await Hive.openBox('todos_box');

    // Listen to network status changes
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final isConnected = results.any((r) => r != ConnectivityResult.none);
      setState(() {
        _isOnline = isConnected;
      });
      if (isConnected) {
        _syncUnsyncedTodos();
      }
    });

    setState(() {
      _isHiveInitialized = true;
    });
  }

  Future<void> _addTodo() async {
    if (_taskController.text.trim().isEmpty) return;
    final taskData = {
      'title': _taskController.text.trim(),
      'isSynced': _isOnline,
      'createdAt': DateTime.now().toIso8601String(),
    };
    await _todoBox.add(taskData);
    _taskController.clear();
    setState(() {});
  }

  Future<void> _syncUnsyncedTodos() async {
    int syncedCount = 0;
    for (int i = 0; i < _todoBox.length; i++) {
      final Map map = Map.from(_todoBox.getAt(i));
      if (map['isSynced'] == false) {
        // Mock REST API Sync
        map['isSynced'] = true;
        await _todoBox.putAt(i, map);
        syncedCount++;
      }
    }
    if (syncedCount > 0 && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Online: Synced $syncedCount pending Hive tasks to mock API!')),
      );
    }
    setState(() {});
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isHiveInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Q23: Offline Todo (Hive & Sync)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              color: _isOnline ? Colors.green.shade100 : Colors.orange.shade100,
              child: Row(
                children: [
                  Icon(_isOnline ? Icons.wifi : Icons.wifi_off, color: _isOnline ? Colors.green : Colors.orange),
                  const SizedBox(width: 8),
                  Text(_isOnline ? 'Online (Tasks sync automatically)' : 'Offline (Saving tasks to Hive locally)'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: TextField(controller: _taskController, decoration: const InputDecoration(labelText: 'Task Title'))),
                IconButton(icon: const Icon(Icons.add), onPressed: _addTodo),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: _todoBox.listenable(),
                builder: (context, Box box, _) {
                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final item = Map.from(box.getAt(index));
                      final bool synced = item['isSynced'] ?? false;
                      return ListTile(
                        leading: Icon(synced ? Icons.cloud_done : Icons.cloud_upload, color: synced ? Colors.green : Colors.grey),
                        title: Text(item['title']),
                        subtitle: Text(synced ? 'Synced to Server' : 'Saved in Hive (Pending Sync)'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
