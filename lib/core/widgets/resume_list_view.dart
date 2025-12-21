import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resume_builder_project/core/screens/download_screen.dart';

import '../screens/resume_information_screen.dart';
import '../utils/app_utils.dart';

class ResumeListView extends StatelessWidget {
  const ResumeListView({super.key});

  // ===== LOAD RESUME FILE =====
  Future<List<Map<String, dynamic>>> _loadResumes() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/resumes_info.json');

    debugPrint('📂 Resume file path: ${file.path}');

    if (!await file.exists()) {
      debugPrint('⚠️ resumes_info.json NOT FOUND');
      return [];
    }

    final content = await file.readAsString();

    if (content.trim().isEmpty) {
      debugPrint('⚠️ resumes_info.json EMPTY');
      return [];
    }

    debugPrint('========== RAW JSON ==========');
    debugPrint(content);
    debugPrint('========== END ==========');

    final List data = jsonDecode(content);

    return data
        .map<Map<String, dynamic>>(
          (e) => Map<String, dynamic>.from(e),
    )
        .toList();
  }
  void _openResume(
      BuildContext context,
      Map<String, dynamic> resume,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResumeInformationScreen(
          resume: resume,
        ),
      ),
    );
  }

  Future<void> _deleteResume(
      BuildContext context,
      Map<String, dynamic> resume,
      ) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/resumes_info.json');

    if (!await file.exists()) return;

    final content = await file.readAsString();
    if (content.trim().isEmpty) return;

    final List data = jsonDecode(content);

    data.removeWhere(
          (e) =>
      e["name"] == resume["name"] &&
          e["createdAt"] == resume["createdAt"],
    );

    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(data),
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Resume deleted")),
      );
    }
  }
  Future<void> _confirmDelete(
      BuildContext context,
      Map<String, dynamic> resume,
      ) async {
    final confirmed = await AppUtils.confirmDelete(context);

    if (!confirmed) return;

    await _deleteResume(context, resume);

    // rebuild list
    if (context.mounted) {
      (context as Element).markNeedsBuild();
    }
  }

  // ===== UI =====
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _loadResumes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "No resume found",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        final resumes = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: resumes.length,
          itemBuilder: (context, index) {
            final item = resumes[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          "assets/images/rate_app.png",
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["name"] ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  item["createdAt"] ?? "",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ACTION ROW 1
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _openResume(context, item),
                          child: const Text("Preview"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _openResume(context, item),
                          child: const Text("Edit"),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // ACTION ROW 2
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            foregroundColor: Colors.black54,
                          ),
                          child: const Text("Copy"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 4,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const DownloadScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            foregroundColor: Colors.black54,
                          ),
                          child: const Text("Download"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: ElevatedButton(
                          onPressed: () => _confirmDelete(context, item),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            foregroundColor: Colors.black54,
                          ),
                          child: const Text("Delete"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
