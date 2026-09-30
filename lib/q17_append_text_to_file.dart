import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Q17: Writes a function that appends new text to an existing file instead of overwriting its previous content.
Future<File> appendTextToFile(String filename, String textToAppend) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$filename');

  // FileMode.append ensures content is appended rather than overwritten
  return await file.writeAsString(
    '$textToAppend\n',
    mode: FileMode.append,
  );
}

class Q17AppendTextToFileScreen extends StatefulWidget {
  const Q17AppendTextToFileScreen({super.key});

  @override
  State<Q17AppendTextToFileScreen> createState() => _Q17AppendTextToFileScreenState();
}

class _Q17AppendTextToFileScreenState extends State<Q17AppendTextToFileScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _fileContents = '';

  Future<void> _handleAppend() async {
    if (_inputController.text.isEmpty) return;
    await appendTextToFile('log_append.txt', _inputController.text);
    _inputController.clear();
    await _readFullFile();
  }

  Future<void> _readFullFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/log_append.txt');
    if (await file.exists()) {
      final content = await file.readAsString();
      setState(() {
        _fileContents = content;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q17: Append Text to File')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _inputController,
              decoration: const InputDecoration(
                labelText: 'Enter text to append',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _handleAppend,
              child: const Text('Append Line to File'),
            ),
            const SizedBox(height: 20),
            const Text('Full File Content (Appended):', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.grey.shade200,
                child: SingleChildScrollView(
                  child: Text(_fileContents.isEmpty ? 'File is empty' : _fileContents),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
