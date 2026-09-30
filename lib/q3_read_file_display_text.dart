import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Q3: Reads the contents of an existing file using readAsString() and displays it in a Text widget.
class Q3ReadFileDisplayTextScreen extends StatefulWidget {
  const Q3ReadFileDisplayTextScreen({super.key});

  @override
  State<Q3ReadFileDisplayTextScreen> createState() => _Q3ReadFileDisplayTextScreenState();
}

class _Q3ReadFileDisplayTextScreenState extends State<Q3ReadFileDisplayTextScreen> {
  String _fileContent = 'Tap button to read file content';

  Future<void> _readFile() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/hello.txt');
      
      if (!await file.exists()) {
        await file.writeAsString('Hello Flutter! Sample text in file.');
      }

      final String content = await file.readAsString();
      setState(() {
        _fileContent = content;
      });
    } catch (e) {
      setState(() {
        _fileContent = 'Failed to read file: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q3: Read File & Display')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _readFile,
              child: const Text('Read File Contents'),
            ),
            const SizedBox(height: 24),
            const Text(
              'File Contents:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _fileContent,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
