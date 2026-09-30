import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

/// Q19: Uses path_provider to copy an image file picked from the gallery into the app's own documents directory.
class Q19CopyPickedImageScreen extends StatefulWidget {
  const Q19CopyPickedImageScreen({super.key});

  @override
  State<Q19CopyPickedImageScreen> createState() => _Q19CopyPickedImageScreenState();
}

class _Q19CopyPickedImageScreenState extends State<Q19CopyPickedImageScreen> {
  File? _copiedImageFile;
  String _status = 'No image picked yet';

  Future<void> _pickAndCopyImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // 1. Get app documents directory
      final appDir = await getApplicationDocumentsDirectory();
      final String fileName = 'copied_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final File targetFile = File('${appDir.path}/$fileName');

      // 2. Copy the picked image file to app documents directory
      final File copied = await File(pickedFile.path).copy(targetFile.path);

      setState(() {
        _copiedImageFile = copied;
        _status = 'Successfully copied to app documents directory:\n${copied.path}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q19: Copy Picked Image to App Doc')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _pickAndCopyImage,
              icon: const Icon(Icons.image),
              label: const Text('Pick Image from Gallery & Copy'),
            ),
            const SizedBox(height: 20),
            Text(_status, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            if (_copiedImageFile != null)
              Expanded(
                child: Image.file(_copiedImageFile!),
              ),
          ],
        ),
      ),
    );
  }
}
