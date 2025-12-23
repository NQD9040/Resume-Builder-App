import 'package:flutter/material.dart';
import '../../services/resume_storage.dart';
import 'package:resume_builder_project/core/utils/app_utils.dart';
import '../../widgets/add_item_card.dart';
import 'form/certification_form.dart';

class CertificationInformationScreen extends StatefulWidget {
  final Map<String, dynamic> resume;

  const CertificationInformationScreen({
    super.key,
    required this.resume,
  });

  @override
  State<CertificationInformationScreen> createState() =>
      _CertificationInformationScreenState();
}

class _CertificationInformationScreenState
    extends State<CertificationInformationScreen>
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
      key: 'certifications',
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
      key: 'certifications',
      value: educations,
    );
  }

  void _openForm({Map<String, dynamic>? data, int? index}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CertificationForm(
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
                    title: "Certification",
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
                          title: Text(exp["certification-name"] ?? ""),
                          subtitle: Text(exp["year"] ?? ""),
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
                        title: "Certification",
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
