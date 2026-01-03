import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:resume_builder_project/core/screens/resume_information_tabs/select_objective_screen.dart';
import '../../services/resume_storage.dart';

class ObjectiveInformationScreen extends StatefulWidget {
  final Map<String, dynamic> resume;

  const ObjectiveInformationScreen({
    super.key,
    required this.resume,
  });

  @override
  State<ObjectiveInformationScreen> createState() =>
      _ObjectiveInformationScreenState();
}

class _ObjectiveInformationScreenState
    extends State<ObjectiveInformationScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late QuillController _quillController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _quillController = QuillController.basic();
    _loadData();
  }

  @override
  void dispose() {
    _quillController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// ===== LOAD DATA =====
  Future<void> _loadData() async {
    final data = await ResumeStorage.loadData(
      resume: widget.resume,
      key: 'objective',
    );

    if (data is String && data.isNotEmpty) {
      final doc = Document.fromJson(jsonDecode(data));

      setState(() {
        _quillController.dispose();
        _quillController = QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
      });
    }
  }

  /// ===== SAVE DATA (CHỈ 1 OBJECTIVE – GHI ĐÈ) =====
  Future<void> _saveData() async {
    final jsonData =
    jsonEncode(_quillController.document.toDelta().toJson());

    await ResumeStorage.saveData(
      resume: widget.resume,
      key: 'objective',
      value: jsonData,
    );
  }

  /// ===== SELECT OBJECTIVE =====
  Future<void> _selectObjective() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => const SelectObjectiveScreen(),
      ),
    );

    if (result == null || result.isEmpty) return;

    final doc = Document.fromJson([
      {
        "insert": "$result\n"
      }
    ]);

    setState(() {
      _quillController.dispose();
      _quillController = QuillController(
        document: doc,
        selection: TextSelection.collapsed(offset: result.length),
      );
    });

    _focusNode.requestFocus();
    _saveData();
  }

  /// ===== CLEAR =====
  void _clearObjective() {
    setState(() {
      _quillController.dispose();
      _quillController = QuillController.basic();
    });
    _saveData();
  }

  /// ===== SAVE BUTTON =====
  void _saveObjective() async {
    await _saveData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// ===== QUILL EDITOR =====
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    /// ===== TOOLBAR (GIỮ NGUYÊN) =====
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: const BoxDecoration(
                        color: Colors.teal,
                        borderRadius:
                        BorderRadius.vertical(top: Radius.circular(8)),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            QuillToolbarToggleStyleButton(
                              controller: _quillController,
                              attribute: Attribute.bold,
                            ),
                            QuillToolbarToggleStyleButton(
                              controller: _quillController,
                              attribute: Attribute.italic,
                            ),
                            QuillToolbarToggleStyleButton(
                              controller: _quillController,
                              attribute: Attribute.underline,
                            ),
                            QuillToolbarToggleStyleButton(
                              controller: _quillController,
                              attribute: Attribute.strikeThrough,
                            ),
                            const SizedBox(width: 6),
                            QuillToolbarToggleStyleButton(
                              controller: _quillController,
                              attribute: Attribute.ul,
                            ),
                            QuillToolbarToggleStyleButton(
                              controller: _quillController,
                              attribute: Attribute.ol,
                            ),
                            const SizedBox(width: 6),
                            QuillToolbarHistoryButton(
                              controller: _quillController,
                              isUndo: true,
                            ),
                            QuillToolbarHistoryButton(
                              controller: _quillController,
                              isUndo: false,
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// ===== EDITOR =====
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: QuillEditor.basic(
                          controller: _quillController,
                          focusNode: _focusNode,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// ===== ACTION BUTTONS =====
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: _selectObjective,
                    icon: const Icon(Icons.upload, color: Colors.white),
                    label: const Text(
                      "Select Objective",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: _clearObjective,
                    icon: const Icon(Icons.close, color: Colors.red),
                    label: const Text(
                      "Clear Objective",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// ===== SAVE =====
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _saveObjective,
                child: const Text(
                  "SAVE",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
