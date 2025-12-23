import 'package:flutter/material.dart';
import 'package:resume_builder_project/core/utils/app_utils.dart';
import '../../services/resume_storage.dart';
import '../../widgets/add_item_card.dart';
import 'form/education_form.dart';

class EducationInformationScreen extends StatefulWidget {
  final Map<String, dynamic> resume;

  const EducationInformationScreen({
    super.key,
    required this.resume,
  });

  @override
  State<EducationInformationScreen> createState() =>
      _EducationInformationScreenState();
}

class _EducationInformationScreenState
    extends State<EducationInformationScreen>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  List<Map<String, dynamic>> educations = [];

  @override
  void initState() {
    super.initState();
    _loadEducation();
  }

  Future<void> _loadEducation() async {
    final raw = await ResumeStorage.loadData(
      resume: widget.resume,
      key: "education",
    );

    setState(() {
      educations = List<Map<String, dynamic>>.from(
        raw as List,
      );
    });
  }

  Future<void> _saveEducation() async {
    await ResumeStorage.saveData(
      resume: widget.resume,
      key: "education",
      value: educations,
    );
  }

  // ===== OPEN FORM =====
  void _openForm({Map<String, dynamic>? data, int? index}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EducationForm(
          data: data,
          onSave: (info) async {
            setState(() {
              if (index != null) {
                educations[index] = info;
              } else {
                educations.add(info);
              }
            });

            await _saveEducation();
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
            if (educations.isEmpty)
              Expanded(
                child: Center(
                  child: AddItemCard(
                    title: "Education",
                    onAdd: () => _openForm(),
                  ),
                ),
              ),

            if (educations.isNotEmpty)
              Expanded(
                child: ListView(
                  children: [
                    ...List.generate(educations.length, (i) {
                      final edu = educations[i];

                      return Card(
                        child: ListTile(
                          title: Text(edu["course-degree"] ?? ""),
                          subtitle: Text(edu["school-university"] ?? ""),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    _openForm(data: edu, index: i),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  final ok =
                                  await AppUtils.confirmDelete(context);
                                  if (ok) {
                                    setState(() {
                                      educations.removeAt(i);
                                    });
                                    await _saveEducation();
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
                        title: "Education",
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
