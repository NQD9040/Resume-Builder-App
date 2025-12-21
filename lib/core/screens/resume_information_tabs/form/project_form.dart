import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'dart:convert';

class ProjectForm extends StatefulWidget {
  final Map<String, dynamic>? data;
  final Function(Map<String, dynamic>) onSave;

  const ProjectForm({super.key, this.data, required this.onSave});

  @override
  State<ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends State<ProjectForm> {
  final _projectCtrl = TextEditingController();
  final _fromCtrl = TextEditingController();
  final _toCtrl = TextEditingController();
  final _roleCtrl = TextEditingController();
  final _teamSizeCtrl = TextEditingController();
  // Quill controller cho rich text
  late QuillController _quillController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Khởi tạo các text field thông thường
    if (widget.data != null) {
      _projectCtrl.text = widget.data!["project-name"] ?? "";
      _fromCtrl.text = widget.data!["from"] ?? "";
      _toCtrl.text = widget.data!["to"] ?? "";
      _roleCtrl.text = widget.data!["role"] ?? "";
      _teamSizeCtrl.text = widget.data!["team-size"] ?? "";
    }

    // Khởi tạo Quill controller
    if (widget.data != null && widget.data!["details"] != null && widget.data!["details"].isNotEmpty) {
      try {
        // Nếu có dữ liệu cũ (JSON format)
        final doc = Document.fromJson(jsonDecode(widget.data!["details"]));
        _quillController = QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (e) {
        // Nếu là plain text cũ, chuyển thành document
        _quillController = QuillController.basic();
        _quillController.document.insert(0, widget.data!["details"]);
      }
    } else {
      _quillController = QuillController.basic();
    }
  }

  @override
  void dispose() {
    _projectCtrl.dispose();
    _fromCtrl.dispose();
    _toCtrl.dispose();
    _roleCtrl.dispose();
    _teamSizeCtrl.dispose();
    _quillController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Project Details"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _projectCtrl,
                      decoration: const InputDecoration(labelText: "Project Name"),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _fromCtrl,
                            decoration: const InputDecoration(labelText: "From"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _toCtrl,
                            decoration: const InputDecoration(labelText: "To"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      controller: _roleCtrl,
                      decoration: const InputDecoration(labelText: "Role"),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: _teamSizeCtrl,
                      decoration: const InputDecoration(labelText: "Team Size"),
                    ),
                    const SizedBox(height: 12),

                    const Text(
                      "Details",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),

                    // Rich Text Editor với toolbar
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          // Toolbar với các nút định dạng
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              border: Border(
                                bottom: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  QuillToolbarHistoryButton(
                                    isUndo: true,
                                    controller: _quillController,
                                  ),
                                  QuillToolbarHistoryButton(
                                    isUndo: false,
                                    controller: _quillController,
                                  ),
                                  const SizedBox(width: 4),
                                  QuillToolbarToggleStyleButton(
                                    options: const QuillToolbarToggleStyleButtonOptions(),
                                    controller: _quillController,
                                    attribute: Attribute.bold,
                                  ),
                                  QuillToolbarToggleStyleButton(
                                    options: const QuillToolbarToggleStyleButtonOptions(),
                                    controller: _quillController,
                                    attribute: Attribute.italic,
                                  ),
                                  QuillToolbarToggleStyleButton(
                                    options: const QuillToolbarToggleStyleButtonOptions(),
                                    controller: _quillController,
                                    attribute: Attribute.underline,
                                  ),
                                  QuillToolbarToggleStyleButton(
                                    options: const QuillToolbarToggleStyleButtonOptions(),
                                    controller: _quillController,
                                    attribute: Attribute.strikeThrough,
                                  ),
                                  const SizedBox(width: 4),
                                  QuillToolbarToggleStyleButton(
                                    options: const QuillToolbarToggleStyleButtonOptions(),
                                    controller: _quillController,
                                    attribute: Attribute.ol,
                                  ),
                                  QuillToolbarToggleStyleButton(
                                    options: const QuillToolbarToggleStyleButtonOptions(),
                                    controller: _quillController,
                                    attribute: Attribute.ul,
                                  ),
                                  QuillToolbarToggleStyleButton(
                                    options: const QuillToolbarToggleStyleButtonOptions(),
                                    controller: _quillController,
                                    attribute: Attribute.unchecked,
                                  ),
                                  const SizedBox(width: 4),
                                  QuillToolbarClearFormatButton(
                                    controller: _quillController,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Editor area
                          Container(
                            height: 200,
                            padding: const EdgeInsets.all(12),
                            child: QuillEditor.basic(
                              controller: _quillController,
                              focusNode: _focusNode,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

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
                        onPressed: () {
                          // Lưu document dưới dạng JSON
                          final deltaJson = jsonEncode(
                              _quillController.document.toDelta().toJson()
                          );

                          widget.onSave({
                            "project-name": _projectCtrl.text,
                            "from": _fromCtrl.text,
                            "to": _toCtrl.text,
                            "role": _roleCtrl.text,
                            "team-size": _teamSizeCtrl.text,
                            "details": deltaJson, // Lưu dưới dạng JSON
                          });
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "SAVE",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}