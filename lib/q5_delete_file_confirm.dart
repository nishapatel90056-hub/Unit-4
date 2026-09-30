import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Q5: Deletes a file using file.delete() and shows a confirmation message to the user.
class Q5DeleteFileConfirmScreen extends StatefulWidget {
  const Q5DeleteFileConfirmScreen({super.key});

  @override
  State<Q5DeleteFileConfirmScreen> createState() => _Q5DeleteFileConfirmScreenState();
}

class _Q5DeleteFileConfirmScreenState extends State<Q5DeleteFileConfirmScreen> {
  String _status = 'Tap below to create/delete file.';

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/deletable_file.txt');
  }

  Future<void> _createFile() async {
    final file = await _getFile();
    await file.writeAsString('File to be deleted');
    setState(() {
      _status = 'File created at:\n${file.path}';
    });
  }

  Future<void> _deleteFile() async {
    final file = await _getFile();
    if (await file.exists()) {
      await file.delete();
      setState(() {
        _status = 'File deleted successfully!';
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Confirmation: File has been deleted successfully!')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File does not exist to delete.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q5: Delete File with Confirmation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _createFile,
              child: const Text('Create File'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade100),
              onPressed: _deleteFile,
              child: const Text('Delete File & Confirm', style: TextStyle(color: Colors.red)),
            ),
            const SizedBox(height: 20),
            Text(_status, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
