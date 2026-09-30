import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Q2: Creates a text file and writes the string "Hello Flutter" into it using writeAsString().
Future<File> writeHelloFlutterToFile() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/hello.txt');
  return await file.writeAsString('Hello Flutter');
}

class Q2WriteStringToFileScreen extends StatefulWidget {
  const Q2WriteStringToFileScreen({super.key});

  @override
  State<Q2WriteStringToFileScreen> createState() => _Q2WriteStringToFileScreenState();
}

class _Q2WriteStringToFileScreenState extends State<Q2WriteStringToFileScreen> {
  String _status = 'File not written yet';

  Future<void> _writeFile() async {
    try {
      final file = await writeHelloFlutterToFile();
      setState(() {
        _status = 'Successfully wrote "Hello Flutter" to:\n${file.path}';
      });
    } catch (e) {
      setState(() {
        _status = 'Error writing file: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q2: Write String to File')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _writeFile,
              child: const Text('Write "Hello Flutter" to File'),
            ),
            const SizedBox(height: 20),
            Text(_status, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
