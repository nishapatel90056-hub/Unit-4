import 'dart:convert';
import 'package:flutter/material.dart';

/// Student model class with toJson() and fromJson() methods
class Student {
  final int id;
  final String name;
  final String department;

  Student({required this.id, required this.name, required this.department});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'department': department,
    };
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as int,
      name: json['name'] as String,
      department: json['department'] as String,
    );
  }

  @override
  String toString() => 'Student(id: $id, name: "$name", department: "$department")';
}

/// Q12: Creates a Student class with toJson() and fromJson() and tests conversion both ways.
class Q12StudentJsonModelScreen extends StatefulWidget {
  const Q12StudentJsonModelScreen({super.key});

  @override
  State<Q12StudentJsonModelScreen> createState() => _Q12StudentJsonModelScreenState();
}

class _Q12StudentJsonModelScreenState extends State<Q12StudentJsonModelScreen> {
  String _toJsonResult = '';
  String _fromJsonResult = '';

  void _testConversion() {
    // 1. Create Student object and convert to JSON
    final student1 = Student(id: 101, name: 'Priya Patel', department: 'Computer Engineering');
    final Map<String, dynamic> mapData = student1.toJson();
    final String jsonString = jsonEncode(mapData);

    // 2. Decode JSON string back to Student object using fromJson
    final Map<String, dynamic> decodedMap = jsonDecode(jsonString);
    final Student student2 = Student.fromJson(decodedMap);

    setState(() {
      _toJsonResult = 'Object -> JSON String:\n$jsonString';
      _fromJsonResult = 'JSON String -> Student Object:\n${student2.toString()}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q12: Student Model JSON Conversion')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _testConversion,
              child: const Text('Test toJson() & fromJson() Conversion'),
            ),
            const SizedBox(height: 20),
            Text(_toJsonResult, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text(_fromJsonResult, style: const TextStyle(fontSize: 16, color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}
