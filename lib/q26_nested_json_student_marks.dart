import 'dart:convert';
import 'package:flutter/material.dart';

class Mark {
  final String subject;
  final int score;

  Mark({required this.subject, required this.score});

  Map<String, dynamic> toJson() => {'subject': subject, 'score': score};

  factory Mark.fromJson(Map<String, dynamic> json) => Mark(
        subject: json['subject'] as String,
        score: json['score'] as int,
      );
}

class StudentWithMarks {
  final int id;
  final String name;
  final List<Mark> marks;

  StudentWithMarks({required this.id, required this.name, required this.marks});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'marks': marks.map((m) => m.toJson()).toList(),
      };

  factory StudentWithMarks.fromJson(Map<String, dynamic> json) => StudentWithMarks(
        id: json['id'] as int,
        name: json['name'] as String,
        marks: (json['marks'] as List<dynamic>).map((m) => Mark.fromJson(m as Map<String, dynamic>)).toList(),
      );
}

/// Q26: Student model containing nested List<Mark> with custom toJson()/fromJson() implementation.
class Q26NestedJsonStudentMarksScreen extends StatefulWidget {
  const Q26NestedJsonStudentMarksScreen({super.key});

  @override
  State<Q26NestedJsonStudentMarksScreen> createState() => _Q26NestedJsonStudentMarksScreenState();
}

class _Q26NestedJsonStudentMarksScreenState extends State<Q26NestedJsonStudentMarksScreen> {
  String _encodedJson = '';
  StudentWithMarks? _decodedStudent;

  void _runNestedJsonTest() {
    final student = StudentWithMarks(
      id: 501,
      name: 'Karan Sharma',
      marks: [
        Mark(subject: 'Mathematics', score: 95),
        Mark(subject: 'Data Structures', score: 88),
        Mark(subject: 'Flutter Development', score: 92),
      ],
    );

    // Encode nested structure
    final String jsonStr = jsonEncode(student.toJson());

    // Decode back into object
    final Map<String, dynamic> decodedMap = jsonDecode(jsonStr);
    final StudentWithMarks restoredStudent = StudentWithMarks.fromJson(decodedMap);

    setState(() {
      _encodedJson = jsonStr;
      _decodedStudent = restoredStudent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q26: Nested JSON Student & Marks')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: _runNestedJsonTest,
                child: const Text('Test Nested toJson() / fromJson()'),
              ),
              const SizedBox(height: 16),
              const Text('Encoded Nested JSON:', style: TextStyle(fontWeight: FontWeight.bold)),
              SelectableText(_encodedJson, style: const TextStyle(color: Colors.green)),
              const SizedBox(height: 20),
              if (_decodedStudent != null) ...[
                Text('Decoded Student: ${_decodedStudent!.name} (ID: ${_decodedStudent!.id})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                const Text('Marks List:'),
                ..._decodedStudent!.marks.map((m) => ListTile(
                      leading: const Icon(Icons.grade),
                      title: Text(m.subject),
                      trailing: Text('${m.score} / 100', style: const TextStyle(fontWeight: FontWeight.bold)),
                    )),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
