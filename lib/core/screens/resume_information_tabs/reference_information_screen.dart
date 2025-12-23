import 'package:flutter/material.dart';
import '../../services/resume_storage.dart';
import 'package:resume_builder_project/core/utils/app_utils.dart';
import '../../widgets/add_item_card.dart';
import 'form/reference_form.dart';

class ReferenceInformationScreen extends StatefulWidget {
  final Map<String, dynamic> resume;

  const ReferenceInformationScreen({
    super.key,
    required this.resume,
  });

  @override
  State<ReferenceInformationScreen> createState() =>
      _ReferenceInformationScreenState();
}

class _ReferenceInformationScreenState
    extends State<ReferenceInformationScreen>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  List<Map<String, dynamic>> educations = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await ResumeStorage.loadData(
      resume: widget.resume,
      key: 'references',
    );

    if (data is List) {
      setState(() {
        educations = List<Map<String, dynamic>>.from(data);
      });
    }
  }

  Future<void> _saveData() async {
    await ResumeStorage.saveData(
      resume: widget.resume,
      key: 'references',
      value: educations,
    );
  }

  void _openForm({Map<String, dynamic>? data, int? index}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReferenceForm(
          data: data,
          onSave: (info) {
            setState(() {
              if (index != null) {
                educations[index] = info;
              } else {
                educations.add(info);
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
            if (educations.isEmpty)
              Expanded(
                child: Center(
                  child: AddItemCard(
                    title: "Reference",
                    onAdd: () => _openForm(),
                  ),
                ),
              ),

            if (educations.isNotEmpty)
              Expanded(
                child: ListView(
                  children: [
                    ...List.generate(educations.length, (i) {
                      final exp = educations[i];

                      return Card(
                        child: ListTile(
                          title: Text(exp["name"] ?? ""),
                          subtitle: Text(exp["job-title"] ?? ""),
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
                                      educations.removeAt(i);
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
                        title: "Reference",
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
