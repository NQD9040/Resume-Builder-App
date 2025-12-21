import 'package:flutter/material.dart';
import 'package:resume_builder_project/core/screens/resume_information_tabs/form/project_form.dart';
import 'package:resume_builder_project/core/utils/app_utils.dart';
import '../../widgets/add_item_card.dart';

class ProjectInformationScreen extends StatefulWidget {
  const ProjectInformationScreen({super.key});

  @override
  State<ProjectInformationScreen> createState() =>
      _ProjectInformationScreenState();
}

class _ProjectInformationScreenState
    extends State<ProjectInformationScreen>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true; // giữ state

  List<Map<String, dynamic>> experiences = [];

  void _openForm({Map<String, dynamic>? data, int? index}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProjectForm(
          data: data,
          onSave: (info) {
            setState(() {
              if (index != null) {
                experiences[index] = info;
              } else {
                experiences.add(info);
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // bắt buộc khi dùng KeepAlive

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Nếu chưa có → show nút add ở giữa
            if (experiences.isEmpty)
              Expanded(
                child: Center(
                  child: AddItemCard(
                    title: "Project",
                    onAdd: () => _openForm(),
                  ),
                ),
              ),

            // Nếu đã có → show list + nút add ở dưới
            if (experiences.isNotEmpty)
              Expanded(
                child: ListView(
                  children: [
                    ...List.generate(experiences.length, (i) {
                      final exp = experiences[i];

                      return Card(
                        child: ListTile(
                          title: Text(exp["project-name"] ?? ""),
                          subtitle: Text(exp["role"] ?? ""),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // EDIT
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _openForm(data: exp, index: i),
                              ),

                              // DELETE + confirm
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  final ok = await AppUtils.confirmDelete(context);
                                  if (ok) {
                                    setState(() {
                                      experiences.removeAt(i); // FIX BUG HERE
                                    });
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
