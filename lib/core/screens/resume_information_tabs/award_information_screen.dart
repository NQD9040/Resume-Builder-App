import 'package:flutter/material.dart';
import 'package:resume_builder_project/core/utils/app_utils.dart';
import '../../widgets/add_item_card.dart';
import 'form/award_form.dart';

class AwardInformationScreen extends StatefulWidget {
  const AwardInformationScreen({super.key});

  @override
  State<AwardInformationScreen> createState() =>
      _AwardInformationScreenState();
}

class _AwardInformationScreenState
    extends State<AwardInformationScreen>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true; // giữ state

  List<Map<String, dynamic>> educations = [];

  void _openForm({Map<String, dynamic>? data, int? index}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AwardForm(
          data: data,
          onSave: (info) {
            setState(() {
              if (index != null) {
                educations[index] = info;
              } else {
                educations.add(info);
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
            if (educations.isEmpty)
              Expanded(
                child: Center(
                  child: AddItemCard(
                    title: "Award",
                    onAdd: () => _openForm(),
                  ),
                ),
              ),

            // Nếu đã có → show list + nút add ở dưới
            if (educations.isNotEmpty)
              Expanded(
                child: ListView(
                  children: [
                    ...List.generate(educations.length, (i) {
                      final exp = educations[i];

                      return Card(
                        child: ListTile(
                          title: Text(exp["award-name"] ?? ""),
                          subtitle: Text(exp["year"] ?? ""),
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
                                      educations.removeAt(i);
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
