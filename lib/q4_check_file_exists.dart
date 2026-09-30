import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Q4: Checks whether a file exists using exists() before attempting to read from it.
class Q4CheckFileExistsScreen extends StatefulWidget {
  const Q4CheckFileExistsScreen({super.key});

  @override
  State<Q4CheckFileExistsScreen> createState() => _Q4CheckFileExistsScreenState();
}

class _Q4CheckFileExistsScreenState extends State<Q4CheckFileExistsScreen> {
  String _result = 'Check file status...';

  Future<void> _checkAndReadFile(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');

    bool fileExists = await file.exists();

    if (fileExists) {
      String content = await file.readAsString();
      setState(() {
        _result = 'File exists!\nContent: "$content"';
      });
    } else {
      setState(() {
        _result = 'File "$filename" does NOT exist! Safe to prevent crash.';
      });
    }
  }

  Future<void> _createSampleFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/sample_test.txt');
    await file.writeAsString('This file was created for testing exists().');
    setState(() {
      _result = 'Created "sample_test.txt" successfully!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q4: Check File Exists')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _createSampleFile,
              child: const Text('Create Sample File'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _checkAndReadFile('sample_test.txt'),
              child: const Text('Check & Read "sample_test.txt"'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _checkAndReadFile('non_existent.txt'),
              child: const Text('Check & Read "non_existent.txt"'),
            ),
            const SizedBox(height: 20),
            Text(
              _result,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
