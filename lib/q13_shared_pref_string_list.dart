import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Q13: Saves a list of Strings to SharedPreferences and displays them in a ListView on app restart.
class Q13SharedPrefStringListScreen extends StatefulWidget {
  const Q13SharedPrefStringListScreen({super.key});

  @override
  State<Q13SharedPrefStringListScreen> createState() => _Q13SharedPrefStringListScreenState();
}

class _Q13SharedPrefStringListScreenState extends State<Q13SharedPrefStringListScreen> {
  final TextEditingController _itemController = TextEditingController();
  List<String> _itemList = [];

  @override
  void initState() {
    super.initState();
    _loadList();
  }

  Future<void> _loadList() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _itemList = prefs.getStringList('string_list_key') ?? [];
    });
  }

  Future<void> _addItem() async {
    if (_itemController.text.trim().isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    _itemList.add(_itemController.text.trim());
    await prefs.setStringList('string_list_key', _itemList);
    _itemController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q13: SharedPref String List')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemController,
                    decoration: const InputDecoration(labelText: 'Enter item'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addItem,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _itemList.isEmpty
                  ? const Center(child: Text('No items in SharedPreferences list.'))
                  : ListView.builder(
                      itemCount: _itemList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(child: Text('${index + 1}')),
                          title: Text(_itemList[index]),
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
