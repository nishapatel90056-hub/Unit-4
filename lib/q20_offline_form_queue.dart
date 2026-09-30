import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Q20: Creates a simple offline queue that saves unsent form data locally using SharedPreferences when offline.
class Q20OfflineFormQueueScreen extends StatefulWidget {
  const Q20OfflineFormQueueScreen({super.key});

  @override
  State<Q20OfflineFormQueueScreen> createState() => _Q20OfflineFormQueueScreenState();
}

class _Q20OfflineFormQueueScreenState extends State<Q20OfflineFormQueueScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isOnline = false;
  List<Map<String, dynamic>> _offlineQueue = [];

  @override
  void initState() {
    super.initState();
    _loadQueue();
  }

  Future<void> _loadQueue() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('offline_form_queue') ?? '[]';
    final List<dynamic> list = jsonDecode(jsonStr);
    setState(() {
      _offlineQueue = List<Map<String, dynamic>>.from(list);
    });
  }

  Future<void> _saveQueue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('offline_form_queue', jsonEncode(_offlineQueue));
  }

  Future<void> _submitForm() async {
    final formData = {
      'name': _nameController.text,
      'email': _emailController.text,
      'timestamp': DateTime.now().toIso8601String(),
    };

    if (_isOnline) {
      // Direct network submission
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Form submitted online directly to server!')),
        );
      }
    } else {
      // Offline: Save to queue in SharedPreferences
      _offlineQueue.add(formData);
      await _saveQueue();
      setState(() {});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Device Offline: Form saved to Offline Queue!')),
        );
      }
    }
    _nameController.clear();
    _emailController.clear();
  }

  Future<void> _syncQueue() async {
    if (!_isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot sync: Device is offline!')),
      );
      return;
    }

    // Simulate sending all queued items to server
    int count = _offlineQueue.length;
    _offlineQueue.clear();
    await _saveQueue();
    setState(() {});

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Synced $count queued items to server successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q20: Offline Form Queue')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Simulate Online / Offline Mode'),
              value: _isOnline,
              activeColor: Colors.green,
              subtitle: Text(_isOnline ? 'Online Mode' : 'Offline Mode'),
              onChanged: (val) => setState(() => _isOnline = val),
            ),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _submitForm, child: const Text('Submit Form')),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _syncQueue,
              icon: const Icon(Icons.sync),
              label: Text('Sync Offline Queue (${_offlineQueue.length})'),
            ),
            const SizedBox(height: 16),
            const Text('Pending Offline Items Queue:', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: _offlineQueue.length,
                itemBuilder: (context, idx) {
                  final item = _offlineQueue[idx];
                  return ListTile(
                    leading: const Icon(Icons.cloud_off, color: Colors.orange),
                    title: Text('${item['name']} (${item['email']})'),
                    subtitle: Text('Queued at: ${item['timestamp']}'),
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
