import 'package:flutter/material.dart';
import 'package:resume_builder_project/core/utils/app_utils.dart';
import '../../widgets/add_item_card.dart';
import 'form/experience_form.dart';

class ExperienceInformationScreen extends StatefulWidget {
  const ExperienceInformationScreen({super.key});

  @override
  State<ExperienceInformationScreen> createState() =>
      _ExperienceInformationScreenState();
}

class _ExperienceInformationScreenState
    extends State<ExperienceInformationScreen>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true; // giữ state

  List<Map<String, dynamic>> experiences = [];

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
            // Nếu chưa có → show nút add ở giữa
            if (experiences.isEmpty)
              Expanded(
                child: Center(
                  child: AddItemCard(
                    title: "Experience",
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
                          title: Text(exp["company"] ?? ""),
                          subtitle: Text(exp["title"] ?? ""),
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
