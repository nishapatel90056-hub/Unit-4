import 'package:flutter/material.dart';

import 'q1_print_app_doc_path.dart';
import 'q2_write_string_to_file.dart';
import 'q3_read_file_display_text.dart';
import 'q4_check_file_exists.dart';
import 'q5_delete_file_confirm.dart';
import 'q6_shared_pref_string.dart';
import 'q7_shared_pref_counter.dart';
import 'q8_in_memory_cache.dart';
import 'q9_map_to_json.dart';
import 'q10_json_to_map.dart';
import 'q11_simple_file_notes.dart';
import 'q12_student_json_model.dart';
import 'q13_shared_pref_string_list.dart';
import 'q14_cache_first_data_loader.dart';
import 'q15_clear_cache_button.dart';
import 'q16_theme_settings_pref.dart';
import 'q17_append_text_to_file.dart';
import 'q18_student_list_file_storage.dart';
import 'q19_copy_picked_image.dart';
import 'q20_offline_form_queue.dart';
import 'q21_notes_crud_json_file.dart';
import 'q22_image_caching_layer.dart';
import 'q23_offline_todo_hive_sync.dart';
import 'q24_generic_repository_pattern.dart';
import 'q25_cached_data_with_expiry.dart';
import 'q26_nested_json_student_marks.dart';
import 'q27_background_sync_connectivity.dart';
import 'q28_file_logger_export.dart';
import 'q29_api_cache_fallback.dart';
import 'q30_complete_offline_data_pipeline.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Practical Questions Menu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MainMenuScreen(),
    );
  }
}

class QuestionItem {
  final String title;
  final String subtitle;
  final Widget screen;

  QuestionItem({required this.title, required this.subtitle, required this.screen});
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<QuestionItem> set1 = [
      QuestionItem(title: 'Q1: App Docs Directory Path', subtitle: 'q1_print_app_doc_path.dart', screen: const Q1PrintAppDocPathScreen()),
      QuestionItem(title: 'Q2: Write String to File', subtitle: 'q2_write_string_to_file.dart', screen: const Q2WriteStringToFileScreen()),
      QuestionItem(title: 'Q3: Read File & Display Text', subtitle: 'q3_read_file_display_text.dart', screen: const Q3ReadFileDisplayTextScreen()),
      QuestionItem(title: 'Q4: Check File Exists', subtitle: 'q4_check_file_exists.dart', screen: const Q4CheckFileExistsScreen()),
      QuestionItem(title: 'Q5: Delete File with Confirm', subtitle: 'q5_delete_file_confirm.dart', screen: const Q5DeleteFileConfirmScreen()),
      QuestionItem(title: 'Q6: Shared Pref String', subtitle: 'q6_shared_pref_string.dart', screen: const Q6SharedPrefStringScreen()),
      QuestionItem(title: 'Q7: Shared Pref Counter', subtitle: 'q7_shared_pref_counter.dart', screen: const Q7SharedPrefCounterScreen()),
      QuestionItem(title: 'Q8: In-Memory Map Cache', subtitle: 'q8_in_memory_cache.dart', screen: const Q8InMemoryCacheScreen()),
      QuestionItem(title: 'Q9: Map to JSON (jsonEncode)', subtitle: 'q9_map_to_json.dart', screen: const Q9MapToJsonScreen()),
      QuestionItem(title: 'Q10: JSON to Map (jsonDecode)', subtitle: 'q10_json_to_map.dart', screen: const Q10JsonToMapScreen()),
    ];

    final List<QuestionItem> set2 = [
      QuestionItem(title: 'Q11: Simple File Notes', subtitle: 'q11_simple_file_notes.dart', screen: const Q11SimpleFileNotesScreen()),
      QuestionItem(title: 'Q12: Student Model JSON', subtitle: 'q12_student_json_model.dart', screen: const Q12StudentJsonModelScreen()),
      QuestionItem(title: 'Q13: Shared Pref String List', subtitle: 'q13_shared_pref_string_list.dart', screen: const Q13SharedPrefStringListScreen()),
      QuestionItem(title: 'Q14: Cache-First Data Loader', subtitle: 'q14_cache_first_data_loader.dart', screen: const Q14CacheFirstDataLoaderScreen()),
      QuestionItem(title: 'Q15: Clear Cache Button', subtitle: 'q15_clear_cache_button.dart', screen: const Q15ClearCacheButtonScreen()),
      QuestionItem(title: 'Q16: Theme Settings Preference', subtitle: 'q16_theme_settings_pref.dart', screen: const Q16ThemeSettingsPrefScreen()),
      QuestionItem(title: 'Q17: Append Text to File', subtitle: 'q17_append_text_to_file.dart', screen: const Q17AppendTextToFileScreen()),
      QuestionItem(title: 'Q18: Student List File Storage', subtitle: 'q18_student_list_file_storage.dart', screen: const Q18StudentListFileStorageScreen()),
      QuestionItem(title: 'Q19: Copy Picked Image', subtitle: 'q19_copy_picked_image.dart', screen: const Q19CopyPickedImageScreen()),
      QuestionItem(title: 'Q20: Offline Form Queue', subtitle: 'q20_offline_form_queue.dart', screen: const Q20OfflineFormQueueScreen()),
    ];

    final List<QuestionItem> set3 = [
      QuestionItem(title: 'Q21: Notes CRUD JSON File', subtitle: 'q21_notes_crud_json_file.dart', screen: const Q21NotesCrudJsonFileScreen()),
      QuestionItem(title: 'Q22: Image Caching Layer', subtitle: 'q22_image_caching_layer.dart', screen: const Q22ImageCachingLayerScreen()),
      QuestionItem(title: 'Q23: Offline Todo Hive & Sync', subtitle: 'q23_offline_todo_hive_sync.dart', screen: const Q23OfflineTodoHiveSyncScreen()),
      QuestionItem(title: 'Q24: Generic Repository Pattern', subtitle: 'q24_generic_repository_pattern.dart', screen: const Q24GenericRepositoryPatternScreen()),
      QuestionItem(title: 'Q25: Cached Data with Expiry', subtitle: 'q25_cached_data_with_expiry.dart', screen: const Q25CachedDataWithExpiryScreen()),
      QuestionItem(title: 'Q26: Nested JSON Student & Marks', subtitle: 'q26_nested_json_student_marks.dart', screen: const Q26NestedJsonStudentMarksScreen()),
      QuestionItem(title: 'Q27: Background Sync Connectivity', subtitle: 'q27_background_sync_connectivity.dart', screen: const Q27BackgroundSyncConnectivityScreen()),
      QuestionItem(title: 'Q28: File Logger & Export', subtitle: 'q28_file_logger_export.dart', screen: const Q28FileLoggerExportScreen()),
      QuestionItem(title: 'Q29: API Cache Fallback', subtitle: 'q29_api_cache_fallback.dart', screen: const Q29ApiCacheFallbackScreen()),
      QuestionItem(title: 'Q30: Complete Offline Data Pipeline', subtitle: 'q30_complete_offline_data_pipeline.dart', screen: const Q30CompleteOfflineDataPipelineScreen()),
    ];

    Widget buildCategory(String categoryTitle, List<QuestionItem> items, Color color) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              categoryTitle,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
          ),
          ...items.map((item) => Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(item.subtitle, style: const TextStyle(color: Colors.grey)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => item.screen));
                  },
                ),
              )),
          const SizedBox(height: 16),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Practical Questions (1 - 30)'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildCategory('Section 1: Basic Operations (Q1 - Q10)', set1, Colors.indigo),
            buildCategory('Section 2: Intermediate Tasks (Q11 - Q20)', set2, Colors.teal),
            buildCategory('Section 3: Advanced Offline & Caching (Q21 - Q30)', set3, Colors.deepOrange),
          ],
        ),
      ),
    );
  }
}
