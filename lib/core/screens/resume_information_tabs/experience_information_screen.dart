import 'package:flutter/material.dart';
import 'package:resume_builder_project/core/utils/app_utils.dart';
import '../../services/resume_storage.dart';
import '../../widgets/add_item_card.dart';
import 'form/experience_form.dart';

class ExperienceInformationScreen extends StatefulWidget {
  final Map<String, dynamic> resume;

  const ExperienceInformationScreen({
    super.key,
    required this.resume,
  });

  @override
  State<ExperienceInformationScreen> createState() =>
      _ExperienceInformationScreenState();
}

class _ExperienceInformationScreenState
    extends State<ExperienceInformationScreen>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  List<Map<String, dynamic>> experiences = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final raw = await ResumeStorage.loadData(
      resume: widget.resume,
      key: "experiences",
    );

    if (raw is List) {
      setState(() {
        experiences = List<Map<String, dynamic>>.from(raw);
      });
    }
  }

  Future<void> _saveData() async {
    await ResumeStorage.saveData(
      resume: widget.resume,
      key: "experiences",
      value: experiences,
    );
  }

  void _openForm({Map<String, dynamic>? data, int? index}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExperienceForm(
          data: data,
          onSave: (info) {
            setState(() {
              if (index != null) {
                experiences[index] = info;
              } else {
                experiences.add(info);
              }
            });
            _saveData();
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
            if (experiences.isEmpty)
              Expanded(
                child: Center(
                  child: AddItemCard(
                    title: "Experience",
                    onAdd: () => _openForm(),
                  ),
                ),
              ),

            if (experiences.isNotEmpty)
              Expanded(
                child: ListView(
                  children: [
                    ...List.generate(experiences.length, (i) {
                      final exp = experiences[i];

                      return Card(
                        child: ListTile(
                          title: Text(exp["company"] ?? ""),
                          subtitle: Text(exp["title"] ?? ""),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    _openForm(data: exp, index: i),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  final ok =
                                  await AppUtils.confirmDelete(context);
                                  if (ok) {
                                    setState(() {
                                      experiences.removeAt(i);
                                    });
                                    _saveData();
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
                        title: "Experience",
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
