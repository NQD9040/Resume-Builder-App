import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resume_builder_project/core/screens/resume_information_screen.dart';

class AddResumeBuilderScreen extends StatefulWidget {
  const AddResumeBuilderScreen({super.key});

  @override
  State<AddResumeBuilderScreen> createState() =>
      _AddResumeBuilderScreenState();
}

class _AddResumeBuilderScreenState extends State<AddResumeBuilderScreen> {
  final TextEditingController _nameCtrl = TextEditingController();

  // ===== FILE HANDLING =====

  Future<File> _getResumeFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/resumes_info.json');
  }

  Future<List<dynamic>> _readResumes() async {
    final file = await _getResumeFile();
    debugPrint('📂 Resume file path: ${file.path}');

    if (!await file.exists()) {
      await file.writeAsString(jsonEncode([]));
      return [];
    }

    final content = await file.readAsString();
    if (content.isEmpty) return [];

    return jsonDecode(content) as List<dynamic>;
  }

  Future<void> _saveResumes(List<dynamic> resumes) async {
    final file = await _getResumeFile();
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(resumes),
    );
  }

  // ===== DEBUG PRINT =====

  Future<void> _debugPrintAllResumes() async {
    final resumes = await _readResumes();

    debugPrint("========== ALL RESUMES JSON ==========");
    debugPrint(const JsonEncoder.withIndent('  ').convert(resumes));
    debugPrint("========== END ==========");
  }

  // ===== CREATE RESUME =====

  Future<void> _createResume() async {
    final name = _nameCtrl.text.trim();

    if (name.isEmpty) {
      _showMsg("Resume name is required");
      return;
    }

    final resumes = await _readResumes();

    final exists = resumes.any(
          (e) =>
      e["name"].toString().toLowerCase() ==
          name.toLowerCase(),
    );

    if (exists) {
      _showMsg("Resume name already exists");
      return;
    }

    /// 🔥 RESUME VỪA TẠO
    final newResume = {
      "name": name,
      "createdAt": DateTime.now().toIso8601String(),
      "data": {},
    };

    resumes.add(newResume);
    await _saveResumes(resumes);

    // DEBUG
    await _debugPrintAllResumes();

    if (!mounted) return;

    /// ✅ TRUYỀN RESUME VỪA TẠO QUA
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResumeInformationScreen(
          resume: newResume,
        ),
      ),
    );
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  // ===== UI =====

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Resume Builder',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 100),

            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: "Enter Resume Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _createResume,
                child: const Text(
                  "Create Resume",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
