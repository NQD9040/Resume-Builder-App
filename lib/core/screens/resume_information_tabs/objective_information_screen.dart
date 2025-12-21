import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class ObjectiveInformationScreen extends StatefulWidget {
  const ObjectiveInformationScreen({super.key});

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
  }

  @override
  void dispose() {
    _quillController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// ====== PLACEHOLDER FUNCTIONS (mày xử sau) ======
  void _selectObjective() {
    // TODO: select objective logic
  }

  void _clearObjective() {
    // TODO: clear objective logic
  }

  void _saveObjective() {
    final jsonData = jsonEncode(
      _quillController.document.toDelta().toJson(),
    );

    Navigator.pop(context, jsonData);
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
                    /// TOOLBAR
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
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
                              attribute: Attribute.ol,
                            ),
                            QuillToolbarToggleStyleButton(
                              controller: _quillController,
                              attribute: Attribute.ul,
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

                    /// EDITOR
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
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
