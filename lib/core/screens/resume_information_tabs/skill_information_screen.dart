import 'package:flutter/material.dart';
import 'package:resume_builder_project/core/utils/app_utils.dart';
import '../../widgets/add_item_card.dart';
import 'form/skill_form.dart';

class SkillInformationScreen extends StatefulWidget {
  const SkillInformationScreen({super.key});

  @override
  State<SkillInformationScreen> createState() =>
      _SkillInformationScreenState();
}

class _SkillInformationScreenState extends State<SkillInformationScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<Map<String, dynamic>> skills = [];

  void _openForm({Map<String, dynamic>? data, int? index}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SkillForm(
          data: data,
          onSave: (info) {
            setState(() {
              if (index != null) {
                skills[index] = info;
              } else {
                skills.add(info);
              }
            });
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
            // CHƯA CÓ SKILL → SHOW ADD Ở GIỮA
            if (skills.isEmpty)
              Expanded(
                child: Center(
                  child: AddItemCard(
                    title: "Skill",
                    onAdd: () => _openForm(),
                  ),
                ),
              ),

            // CÓ SKILL → SHOW LIST
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
                                  (index) => Icon(
                                index < (sk["rating"] ?? 0)
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
                              // EDIT
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    _openForm(data: sk, index: i),
                              ),

                              // DELETE
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  final ok =
                                  await AppUtils.confirmDelete(context);
                                  if (ok) {
                                    setState(() {
                                      skills.removeAt(i);
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

                    // ADD BUTTON CUỐI LIST
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
