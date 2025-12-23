import 'package:flutter/material.dart';
import 'package:resume_builder_project/core/screens/resume_information_tabs/form/project_form.dart';
import 'package:resume_builder_project/core/utils/app_utils.dart';
import '../../services/resume_storage.dart';
import '../../widgets/add_item_card.dart';

class ProjectInformationScreen extends StatefulWidget {
  final Map<String, dynamic> resume;

  const ProjectInformationScreen({
    super.key,
    required this.resume,
  });

  @override
  State<ProjectInformationScreen> createState() =>
      _ProjectInformationScreenState();
}

class _ProjectInformationScreenState
    extends State<ProjectInformationScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<Map<String, dynamic>> projects = [];

  // ===== LOAD =====
  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    final raw = await ResumeStorage.loadData(
      resume: widget.resume,
      key: "project",
    );

    if (raw is List) {
      setState(() {
        projects = List<Map<String, dynamic>>.from(raw);
      });
    }
  }

  // ===== SAVE =====
  Future<void> _saveProjects() async {
    await ResumeStorage.saveData(
      resume: widget.resume,
      key: "project",
      value: projects,
    );
  }

  // ===== OPEN FORM =====
  void _openForm({Map<String, dynamic>? data, int? index}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProjectForm(
          data: data,
          onSave: (info) async {
            setState(() {
              if (index != null) {
                projects[index] = info;
              } else {
                projects.add(info);
              }
            });

            await _saveProjects();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (projects.isEmpty)
              Expanded(
                child: Center(
                  child: AddItemCard(
                    title: "Project",
                    onAdd: () => _openForm(),
                  ),
                ),
              ),

            if (projects.isNotEmpty)
              Expanded(
                child: ListView(
                  children: [
                    ...List.generate(projects.length, (i) {
                      final p = projects[i];

                      return Card(
                        child: ListTile(
                          title: Text(p["project-name"] ?? ""),
                          subtitle: Text(p["role"] ?? ""),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    _openForm(data: p, index: i),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  final ok =
                                  await AppUtils.confirmDelete(context);
                                  if (ok) {
                                    setState(() {
                                      projects.removeAt(i);
                                    });
                                    await _saveProjects();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 12),

                    Center(
                      child: AddItemCard(
                        title: "Project",
                        onAdd: () => _openForm(),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
