import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ResumeStorage {
  static const _fileName = 'resumes_info.json';

  // ===== LOAD =====
  static Future<dynamic> loadData({
    required Map<String, dynamic> resume,
    required String key,
  }) async {
    final data = resume["data"] ?? {};
    return data[key];
  }

  // ===== SAVE =====
  static Future<void> saveData({
    required Map<String, dynamic> resume,
    required String key,
    required dynamic value,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_fileName');

    final List all = jsonDecode(await file.readAsString());

    final index = all.indexWhere(
          (e) =>
      e["name"] == resume["name"] &&
          e["createdAt"] == resume["createdAt"],
    );

    if (index == -1) return;

    all[index]["data"] ??= {};
    all[index]["data"][key] = value;

    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(all),
    );
  }
}
