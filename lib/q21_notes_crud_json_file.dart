import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Note {
  final String id;
  String title;
  String content;

  Note({required this.id, required this.title, required this.content});

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'content': content};

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'] as String,
        title: json['title'] as String,
        content: json['content'] as String,
      );
}

/// Q21: Complete Notes app with CRUD operations storing all notes as a single JSON-encoded list in a file.
class Q21NotesCrudJsonFileScreen extends StatefulWidget {
  const Q21NotesCrudJsonFileScreen({super.key});

  @override
  State<Q21NotesCrudJsonFileScreen> createState() => _Q21NotesCrudJsonFileScreenState();
}

class _Q21NotesCrudJsonFileScreenState extends State<Q21NotesCrudJsonFileScreen> {
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotesFromFile();
  }

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/all_notes_crud.json');
  }

  Future<void> _saveNotesToFile() async {
    final file = await _getFile();
    final jsonList = _notes.map((n) => n.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  Future<void> _loadNotesFromFile() async {
    final file = await _getFile();
    if (await file.exists()) {
      final jsonStr = await file.readAsString();
      final List<dynamic> list = jsonDecode(jsonStr);
      setState(() {
        _notes = list.map((e) => Note.fromJson(e)).toList();
      });
    }
  }

  void _showNoteDialog([Note? existingNote]) {
    final titleController = TextEditingController(text: existingNote?.title ?? '');
    final contentController = TextEditingController(text: existingNote?.content ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existingNote == null ? 'Create Note' : 'Edit Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: contentController, decoration: const InputDecoration(labelText: 'Content')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (existingNote == null) {
                // Create
                final newNote = Note(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  content: contentController.text,
                );
                setState(() => _notes.add(newNote));
              } else {
                // Update
                setState(() {
                  existingNote.title = titleController.text;
                  existingNote.content = contentController.text;
                });
              }
              _saveNotesToFile();
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteNote(String id) {
    setState(() {
      _notes.removeWhere((note) => note.id == id);
    });
    _saveNotesToFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q21: Notes CRUD (JSON File)')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteDialog(),
        child: const Icon(Icons.add),
      ),
      body: _notes.isEmpty
          ? const Center(child: Text('No notes created yet. Tap + to create one.'))
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (ctx, index) {
                final note = _notes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(note.content),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showNoteDialog(note)),
                        IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteNote(note.id)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
