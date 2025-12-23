import 'package:flutter/material.dart';
import 'package:resume_builder_project/core/utils/app_utils.dart';
import '../../services/resume_storage.dart';
import '../../widgets/add_item_card.dart';
import 'form/skill_form.dart';

class SkillInformationScreen extends StatefulWidget {
  final Map<String, dynamic> resume;

  const SkillInformationScreen({
    super.key,
    required this.resume,
  });

  @override
  State<SkillInformationScreen> createState() =>
      _SkillInformationScreenState();
}

class _SkillInformationScreenState extends State<SkillInformationScreen>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  List<Map<String, dynamic>> skills = [];

  @override
  void initState() {
    super.initState();
    _loadSkills();
  }

  // ===== LOAD =====
  Future<void> _loadSkills() async {
    final data = await ResumeStorage.loadData(
      resume: widget.resume,
      key: "skills",
    );

    if (data != null && data is List) {
      setState(() {
        skills = List<Map<String, dynamic>>.from(
          data.map((e) => Map<String, dynamic>.from(e)),
        );
      });
    }
  }

  // ===== SAVE =====
  Future<void> _saveSkills() async {
    await ResumeStorage.saveData(
      resume: widget.resume,
      key: "skills",
      value: skills,
    );
  }

  void _openForm({Map<String, dynamic>? data, int? index}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SkillForm(
          data: data,
          onSave: (info) async {
            setState(() {
              if (index != null) {
                skills[index] = info;
              } else {
                skills.add(info);
              }
            });
            await _saveSkills();
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
            if (skills.isEmpty)
              Expanded(
                child: Center(
                  child: AddItemCard(
                    title: "Skill",
                    onAdd: () => _openForm(),
                  ),
                ),
              ),

            if (skills.isNotEmpty)
              Expanded(
                child: ListView(
                  children: [
                    ...List.generate(skills.length, (i) {
                      final sk = skills[i];

                      return Card(
                        child: ListTile(
                          title: Text(sk["name"] ?? ""),
                          subtitle: Row(
                            children: List.generate(
                              5,
                                  (idx) => Icon(
                                idx < (sk["rating"] ?? 0)
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 20,
                              ),
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    _openForm(data: sk, index: i),
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
                                      skills.removeAt(i);
                                    });
                                    await _saveSkills();
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
                        title: "Skill",
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
