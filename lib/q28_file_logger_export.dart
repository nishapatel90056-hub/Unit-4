import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Q28: File-based logging system that appends timestamped log entries to a file & allows export/share.
class AppFileLogger {
  static Future<File> _getLogFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/app_activity.log');
  }

  static Future<void> log(String message) async {
    final file = await _getLogFile();
    final timestamp = DateTime.now().toIso8601String();
    final logEntry = '[$timestamp] $message\n';
    await file.writeAsString(logEntry, mode: FileMode.append);
  }

  static Future<String> readLogs() async {
    final file = await _getLogFile();
    if (await file.exists()) {
      return await file.readAsString();
    }
    return 'No log entries found.';
  }

  static Future<void> exportOrShareLogs() async {
    final file = await _getLogFile();
    if (await file.exists()) {
      await Share.shareXFiles([XFile(file.path)], text: 'Exported App Log File');
    }
  }

  static Future<void> clearLogs() async {
    final file = await _getLogFile();
    if (await file.exists()) {
      await file.delete();
    }
  }
}

class Q28FileLoggerExportScreen extends StatefulWidget {
  const Q28FileLoggerExportScreen({super.key});

  @override
  State<Q28FileLoggerExportScreen> createState() => _Q28FileLoggerExportScreenState();
}

class _Q28FileLoggerExportScreenState extends State<Q28FileLoggerExportScreen> {
  final TextEditingController _logMessageController = TextEditingController();
  String _logs = '';

  @override
  void initState() {
    super.initState();
    _refreshLogs();
  }

  Future<void> _refreshLogs() async {
    final text = await AppFileLogger.readLogs();
    setState(() {
      _logs = text;
    });
  }

  Future<void> _addLog() async {
    if (_logMessageController.text.trim().isEmpty) return;
    await AppFileLogger.log(_logMessageController.text.trim());
    _logMessageController.clear();
    await _refreshLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q28: File Logger & Export')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _logMessageController,
              decoration: const InputDecoration(
                labelText: 'Enter Log Message',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _addLog,
                    icon: const Icon(Icons.add_comment),
                    label: const Text('Log Entry'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: AppFileLogger.exportOrShareLogs,
                    icon: const Icon(Icons.share, color: Colors.white),
                    label: const Text('Export/Share Log File', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () async {
                await AppFileLogger.clearLogs();
                await _refreshLogs();
              },
              child: const Text('Clear All Logs'),
            ),
            const SizedBox(height: 16),
            const Text('App Log File Contents:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.black87,
                child: SingleChildScrollView(
                  child: Text(
                    _logs,
                    style: const TextStyle(color: Colors.greenAccent, fontFamily: 'monospace'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
