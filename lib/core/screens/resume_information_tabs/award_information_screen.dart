import 'package:flutter/material.dart';
import 'package:resume_builder_project/core/utils/app_utils.dart';
import '../../widgets/add_item_card.dart';
import 'form/award_form.dart';
import '../../services/resume_storage.dart';

class AwardInformationScreen extends StatefulWidget {
  final Map<String, dynamic> resume;

  const AwardInformationScreen({
    super.key,
    required this.resume,
  });

  @override
  State<AwardInformationScreen> createState() =>
      _AwardInformationScreenState();
}

class _AwardInformationScreenState
    extends State<AwardInformationScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<Map<String, dynamic>> awards = [];

  @override
  void initState() {
    super.initState();
    _loadAwards();
  }

  // ===== LOAD =====
  Future<void> _loadAwards() async {
    final data = await ResumeStorage.loadData(
      resume: widget.resume,
      key: "award",
    );

    if (data is List) {
      awards = data.map<Map<String, dynamic>>(
            (e) => Map<String, dynamic>.from(e),
      ).toList();
    }

    setState(() {});
  }

  // ===== SAVE =====
  Future<void> _saveAwards() async {
    await ResumeStorage.saveData(
      resume: widget.resume,
      key: "award",
      value: awards,
    );
  }

  // ===== OPEN FORM =====
  void _openForm({Map<String, dynamic>? data, int? index}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AwardForm(
          data: data,
          onSave: (info) async {
            setState(() {
              if (index != null) {
                awards[index] = info;
              } else {
                awards.add(info);
              }
            });

            await _saveAwards();
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
            // ===== EMPTY =====
            if (awards.isEmpty)
              Expanded(
                child: Center(
                  child: AddItemCard(
                    title: "Award",
                    onAdd: () => _openForm(),
                  ),
                ),
              ),

            // ===== LIST =====
            if (awards.isNotEmpty)
              Expanded(
                child: ListView(
                  children: [
                    ...List.generate(awards.length, (i) {
                      final aw = awards[i];

                      return Card(
                        child: ListTile(
                          title: Text(aw["award-name"] ?? ""),
                          subtitle: Text(aw["year"] ?? ""),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // EDIT
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    _openForm(data: aw, index: i),
                              ),

                              // DELETE
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  final ok =
                                  await AppUtils.confirmDelete(context);
                                  if (!ok) return;

                                  setState(() {
                                    awards.removeAt(i);
                                  });

                                  await _saveAwards();
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
                        title: "Award",
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
