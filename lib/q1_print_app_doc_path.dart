import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Q1: Writes a Dart function that prints the path returned by getApplicationDocumentsDirectory().
Future<String> printAppDocumentsDirectoryPath() async {
  final Directory dir = await getApplicationDocumentsDirectory();
  print('Application Documents Directory Path: ${dir.path}');
  return dir.path;
}

class Q1PrintAppDocPathScreen extends StatefulWidget {
  const Q1PrintAppDocPathScreen({super.key});

  @override
  State<Q1PrintAppDocPathScreen> createState() => _Q1PrintAppDocPathScreenState();
}

class _Q1PrintAppDocPathScreenState extends State<Q1PrintAppDocPathScreen> {
  String _path = 'Press button to fetch path';

  Future<void> _handlePrintPath() async {
    final path = await printAppDocumentsDirectoryPath();
    setState(() {
      _path = path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q1: App Docs Directory Path')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _handlePrintPath,
              child: const Text('Get & Print App Docs Directory'),
            ),
            const SizedBox(height: 20),
            SelectableText(
              'Path: $_path',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
