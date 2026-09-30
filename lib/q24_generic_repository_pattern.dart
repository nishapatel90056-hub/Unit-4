import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Abstract Local Data Source
abstract class LocalDataSource<T> {
  Future<List<T>> getLocalData();
  Future<void> saveLocalData(List<T> items);
}

/// Abstract Remote Data Source
abstract class RemoteDataSource<T> {
  Future<List<T>> getRemoteData();
}

/// Generic Repository Class abstracting local and remote data sources
class GenericRepository<T> {
  final LocalDataSource<T> localDataSource;
  final RemoteDataSource<T> remoteDataSource;

  GenericRepository({required this.localDataSource, required this.remoteDataSource});

  Future<List<T>> getData({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final localData = await localDataSource.getLocalData();
      if (localData.isNotEmpty) {
        return localData;
      }
    }
    // Fetch from remote
    final remoteData = await remoteDataSource.getRemoteData();
    await localDataSource.saveLocalData(remoteData);
    return remoteData;
  }
}

/// Implementation for Item list
class SharedPreferencesItemLocalDataSource implements LocalDataSource<String> {
  @override
  Future<List<String>> getLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('repo_cache') ?? [];
  }

  @override
  Future<void> saveLocalData(List<String> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('repo_cache', items);
  }
}

class ApiItemRemoteDataSource implements RemoteDataSource<String> {
  @override
  Future<List<String>> getRemoteData() async {
    final res = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=5'));
    if (res.statusCode == 200) {
      final List<dynamic> list = jsonDecode(res.body);
      return list.map((item) => item['title'].toString()).toList();
    }
    return ['Fallback Title 1', 'Fallback Title 2'];
  }
}

/// Q24: Demonstrates generic Repository pattern UI
class Q24GenericRepositoryPatternScreen extends StatefulWidget {
  const Q24GenericRepositoryPatternScreen({super.key});

  @override
  State<Q24GenericRepositoryPatternScreen> createState() => _Q24GenericRepositoryPatternScreenState();
}

class _Q24GenericRepositoryPatternScreenState extends State<Q24GenericRepositoryPatternScreen> {
  late GenericRepository<String> _repository;
  List<String> _items = [];
  String _sourceStatus = '';

  @override
  void initState() {
    super.initState();
    _repository = GenericRepository<String>(
      localDataSource: SharedPreferencesItemLocalDataSource(),
      remoteDataSource: ApiItemRemoteDataSource(),
    );
    _loadItems(forceRefresh: false);
  }

  Future<void> _loadItems({required bool forceRefresh}) async {
    setState(() => _sourceStatus = forceRefresh ? 'Fetching from Remote API...' : 'Checking Local Cache...');
    final data = await _repository.getData(forceRefresh: forceRefresh);
    setState(() {
      _items = data;
      _sourceStatus = forceRefresh ? 'Loaded & Cached from Remote API' : 'Loaded from Repository Data Source';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q24: Generic Repository Pattern')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: ElevatedButton(onPressed: () => _loadItems(forceRefresh: false), child: const Text('Get Data (Local First)'))),
                const SizedBox(width: 8),
                Expanded(child: OutlinedButton(onPressed: () => _loadItems(forceRefresh: true), child: const Text('Force Remote Refresh'))),
              ],
            ),
            const SizedBox(height: 12),
            Text(_sourceStatus, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (ctx, idx) => ListTile(
                  leading: CircleAvatar(child: Text('${idx + 1}')),
                  title: Text(_items[idx]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
