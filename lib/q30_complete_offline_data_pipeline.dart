import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class PipelineItem {
  final int id;
  String title;
  bool isLocallyEdited;

  PipelineItem({required this.id, required this.title, this.isLocallyEdited = false});

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isLocallyEdited': isLocallyEdited,
      };

  factory PipelineItem.fromJson(Map<String, dynamic> json) => PipelineItem(
        id: json['id'] as int,
        title: json['title'] as String,
        isLocallyEdited: json['isLocallyEdited'] as bool? ?? false,
      );
}

/// Q30: Complete offline-data pipeline (Fetch API -> Serialize JSON to file -> Deserialize on launch -> Display -> Local Edits -> Re-sync).
class Q30CompleteOfflineDataPipelineScreen extends StatefulWidget {
  const Q30CompleteOfflineDataPipelineScreen({super.key});

  @override
  State<Q30CompleteOfflineDataPipelineScreen> createState() => _Q30CompleteOfflineDataPipelineScreenState();
}

class _Q30CompleteOfflineDataPipelineScreenState extends State<Q30CompleteOfflineDataPipelineScreen> {
  List<PipelineItem> _items = [];
  String _pipelineStatus = 'Pipeline Initializing...';

  @override
  void initState() {
    super.initState();
    _startPipeline();
  }

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/pipeline_data.json');
  }

  // 1. Pipeline Launch: Check for local file, deserialize on app launch
  Future<void> _startPipeline() async {
    final file = await _getFile();
    if (await file.exists()) {
      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(jsonString);
      setState(() {
        _items = jsonList.map((e) => PipelineItem.fromJson(e)).toList();
        _pipelineStatus = 'Pipeline Launch: Deserialized ${_items.length} records from local disk file.';
      });
    } else {
      // If file doesn't exist, fetch from network API
      await _fetchFromNetworkApi();
    }
  }

  // 2. Fetch from API, serialize to JSON, save to file
  Future<void> _fetchFromNetworkApi() async {
    setState(() => _pipelineStatus = 'Fetching initial dataset from API...');
    try {
      final res = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=6'));
      if (res.statusCode == 200) {
        final List<dynamic> rawList = jsonDecode(res.body);
        _items = rawList.map((e) => PipelineItem(id: e['id'], title: e['title'])).toList();

        // Save to file
        await _saveItemsToFile();

        setState(() {
          _pipelineStatus = 'Fetched from Network -> Serialized & Saved to File!';
        });
      }
    } catch (e) {
      setState(() => _pipelineStatus = 'Network error fetching initial data: $e');
    }
  }

  // 3. Serialize list to JSON and write to file
  Future<void> _saveItemsToFile() async {
    final file = await _getFile();
    final jsonList = _items.map((i) => i.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  // 4. Allow Local Edits
  void _editItem(PipelineItem item) {
    final controller = TextEditingController(text: item.title);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit Item #${item.id}'),
        content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Title')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                item.title = controller.text;
                item.isLocallyEdited = true;
              });
              await _saveItemsToFile();
              if (mounted) Navigator.pop(ctx);
            },
            child: const Text('Save Local Edit'),
          ),
        ],
      ),
    );
  }

  // 5. Re-sync changes back to server
  Future<void> _resyncChangesToServer() async {
    final editedItems = _items.where((i) => i.isLocallyEdited).toList();
    if (editedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No local edits found to sync.')),
      );
      return;
    }

    setState(() => _pipelineStatus = 'Re-syncing ${editedItems.length} edited records to server...');
    await Future.delayed(const Duration(seconds: 2)); // Simulate PUT/PATCH REST request

    for (var item in editedItems) {
      item.isLocallyEdited = false;
    }
    await _saveItemsToFile();

    setState(() => _pipelineStatus = 'RE-SYNC COMPLETE! All local edits updated on server & marked synced.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q30: Complete Offline Pipeline')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(_pipelineStatus, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _resyncChangesToServer,
                    icon: const Icon(Icons.cloud_upload),
                    label: const Text('Re-sync Edits to Server'),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: _fetchFromNetworkApi,
                  child: const Text('Refetch API'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (ctx, idx) {
                  final item = _items[idx];
                  return Card(
                    color: item.isLocallyEdited ? Colors.amber.shade50 : null,
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${item.id}')),
                      title: Text(item.title),
                      subtitle: Text(item.isLocallyEdited ? 'Locally Edited (Pending Re-sync)' : 'Synced with Server'),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editItem(item),
                      ),
                    ),
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
