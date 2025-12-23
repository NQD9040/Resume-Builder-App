import 'package:flutter/material.dart';
import 'package:resume_builder_project/core/utils/app_utils.dart';
import '../../widgets/add_item_card.dart';
import 'form/activity_form.dart';
import '../../services/resume_storage.dart';

class ActivityInformationScreen extends StatefulWidget {
  final Map<String, dynamic> resume;

  const ActivityInformationScreen({
    super.key,
    required this.resume,
  });

  @override
  State<ActivityInformationScreen> createState() =>
      _ActivityInformationScreenState();
}

class _ActivityInformationScreenState
    extends State<ActivityInformationScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<Map<String, dynamic>> activities = [];

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  // ===== LOAD =====
  Future<void> _loadActivities() async {
    final data = await ResumeStorage.loadData(
      resume: widget.resume,
      key: "activity",
    );

    if (data is List) {
      activities = data
          .map<Map<String, dynamic>>(
            (e) => Map<String, dynamic>.from(e),
      )
          .toList();
    }

    setState(() {});
  }

  // ===== SAVE =====
  Future<void> _saveActivities() async {
    await ResumeStorage.saveData(
      resume: widget.resume,
      key: "activity",
      value: activities,
    );
  }

  // ===== OPEN FORM =====
  void _openForm({Map<String, dynamic>? data, int? index}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ActivityForm(
          data: data,
          onSave: (info) async {
            setState(() {
              if (index != null) {
                activities[index] = info;
              } else {
                activities.add(info);
              }
            });

            await _saveActivities();
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
            if (activities.isEmpty)
              Expanded(
                child: Center(
                  child: AddItemCard(
                    title: "Activity",
                    onAdd: () => _openForm(),
                  ),
                ),
              ),

            // ===== LIST =====
            if (activities.isNotEmpty)
              Expanded(
                child: ListView(
                  children: [
                    ...List.generate(activities.length, (i) {
                      final act = activities[i];

                      return Card(
                        child: ListTile(
                          title: Text(act["organization-name"] ?? ""),
                          subtitle: Text(act["role"] ?? ""),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // EDIT
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    _openForm(data: act, index: i),
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
                                    activities.removeAt(i);
                                  });

                                  await _saveActivities();
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
                        title: "Activity",
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
