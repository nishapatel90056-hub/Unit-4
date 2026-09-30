import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Q22: Implements an image caching layer (using flutter_cache_manager) for images downloaded from network.
class Q22ImageCachingLayerScreen extends StatefulWidget {
  const Q22ImageCachingLayerScreen({super.key});

  @override
  State<Q22ImageCachingLayerScreen> createState() => _Q22ImageCachingLayerScreenState();
}

class _Q22ImageCachingLayerScreenState extends State<Q22ImageCachingLayerScreen> {
  final String _imageUrl = 'https://picsum.photos/400/300';
  File? _cachedImageFile;
  String _status = 'Tap to fetch/cache image';

  Future<void> _fetchAndCacheImage() async {
    setState(() {
      _status = 'Fetching image and caching locally...';
    });

    try {
      // DefaultCacheManager downloads and caches file locally on disk
      final file = await DefaultCacheManager().getSingleFile(_imageUrl);
      setState(() {
        _cachedImageFile = file;
        _status = 'Image cached on disk at:\n${file.path}';
      });
    } catch (e) {
      setState(() {
        _status = 'Error fetching image: $e';
      });
    }
  }

  Future<void> _clearImageCache() async {
    await DefaultCacheManager().emptyCache();
    setState(() {
      _cachedImageFile = null;
      _status = 'Image cache cleared!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q22: Image Caching Layer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _fetchAndCacheImage,
              child: const Text('Download & Cache Image'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _clearImageCache,
              child: const Text('Clear Image Cache'),
            ),
            const SizedBox(height: 16),
            Text(_status, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            if (_cachedImageFile != null)
              Expanded(
                child: Image.file(_cachedImageFile!),
              ),
          ],
        ),
      ),
    );
  }
}
