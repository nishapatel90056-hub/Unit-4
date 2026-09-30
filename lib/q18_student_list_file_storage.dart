import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class StudentRecord {
  final String name;
  final int age;

  StudentRecord({required this.name, required this.age});

  Map<String, dynamic> toJson() => {'name': name, 'age': age};

  factory StudentRecord.fromJson(Map<String, dynamic> json) => StudentRecord(
        name: json['name'] as String,
        age: json['age'] as int,
      );
}

/// Q18: Stores a list of Student objects as JSON in a file and reads them back into a usable list.
class Q18StudentListFileStorageScreen extends StatefulWidget {
  const Q18StudentListFileStorageScreen({super.key});

  @override
  State<Q18StudentListFileStorageScreen> createState() => _Q18StudentListFileStorageScreenState();
}

class _Q18StudentListFileStorageScreenState extends State<Q18StudentListFileStorageScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  List<StudentRecord> _students = [];

  @override
  void initState() {
    super.initState();
    _loadStudentsFromFile();
  }

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/students.json');
  }

  Future<void> _saveStudentsToFile() async {
    final file = await _getFile();
    final jsonList = _students.map((s) => s.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await file.writeAsString(jsonString);
  }

  Future<void> _loadStudentsFromFile() async {
    final file = await _getFile();
    if (await file.exists()) {
      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(jsonString);
      setState(() {
        _students = jsonList.map((e) => StudentRecord.fromJson(e)).toList();
      });
    }
  }

  void _addStudent() {
    if (_nameController.text.isEmpty || _ageController.text.isEmpty) return;
    final newStudent = StudentRecord(
      name: _nameController.text,
      age: int.tryParse(_ageController.text) ?? 20,
    );
    setState(() {
      _students.add(newStudent);
    });
    _saveStudentsToFile();
    _nameController.clear();
    _ageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q18: Student List JSON File Storage')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Student Name')),
            TextField(controller: _ageController, decoration: const InputDecoration(labelText: 'Age'), keyboardType: TextInputType.number),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _addStudent, child: const Text('Add & Save to File')),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _students.length,
                itemBuilder: (context, index) {
                  final s = _students[index];
                  return ListTile(
                    leading: const Icon(Icons.school),
                    title: Text(s.name),
                    subtitle: Text('Age: ${s.age}'),
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
