import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Q11: Simple Notes app where a note typed by the user is saved to, and loaded from, a local file.
class Q11SimpleFileNotesScreen extends StatefulWidget {
  const Q11SimpleFileNotesScreen({super.key});

  @override
  State<Q11SimpleFileNotesScreen> createState() => _Q11SimpleFileNotesScreenState();
}

class _Q11SimpleFileNotesScreenState extends State<Q11SimpleFileNotesScreen> {
  final TextEditingController _noteController = TextEditingController();
  String _savedNote = '';

  @override
  void initState() {
    super.initState();
    _loadNoteFromFile();
  }

  Future<File> _getNoteFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/single_note.txt');
  }

  Future<void> _saveNoteToFile() async {
    final file = await _getNoteFile();
    await file.writeAsString(_noteController.text);
    setState(() {
      _savedNote = _noteController.text;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note saved to local file!')),
      );
    }
  }

  Future<void> _loadNoteFromFile() async {
    final file = await _getNoteFile();
    if (await file.exists()) {
      final content = await file.readAsString();
      setState(() {
        _savedNote = content;
        _noteController.text = content;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q11: Simple File Notes App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _noteController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Type Note Here',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveNoteToFile,
                    child: const Text('Save Note'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _loadNoteFromFile,
                    child: const Text('Load Note'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Note Loaded From File:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.yellow.shade100,
              child: Text(_savedNote.isEmpty ? '(No note saved yet)' : _savedNote),
            ),
          ],
        ),
      ),
    );
  }
}
