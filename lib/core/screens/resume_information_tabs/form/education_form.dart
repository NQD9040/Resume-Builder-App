import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'dart:convert';

class EducationForm extends StatefulWidget {
  final Map<String, dynamic>? data;
  final Function(Map<String, dynamic>) onSave;

  const EducationForm({super.key, this.data, required this.onSave});

  @override
  State<EducationForm> createState() => _EducationFormState();
}

class _EducationFormState extends State<EducationForm> {
  final _courseCtrl = TextEditingController();
  final _fromCtrl = TextEditingController();
  final _toCtrl = TextEditingController();
  final _schoolCtrl = TextEditingController();
  final _gradeCtrl = TextEditingController();

  // Quill controller cho rich text
  late QuillController _quillController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Khởi tạo các text field thông thường
    if (widget.data != null) {
      _courseCtrl.text = widget.data!["course-degree"] ?? "";
      _fromCtrl.text = widget.data!["from"] ?? "";
      _toCtrl.text = widget.data!["to"] ?? "";
      _schoolCtrl.text = widget.data!["school-university"] ?? "";
      _gradeCtrl.text = widget.data!["grade-score"] ?? "";
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
    _courseCtrl.dispose();
    _fromCtrl.dispose();
    _toCtrl.dispose();
    _schoolCtrl.dispose();
    _gradeCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Education Details"),
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
                      controller: _courseCtrl,
                      decoration: const InputDecoration(labelText: "Course / Degree"),
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
                      controller: _schoolCtrl,
                      decoration: const InputDecoration(labelText: "School / University"),
                    ),

                    const SizedBox(height: 20),
                    TextField(
                      controller: _gradeCtrl,
                      decoration: const InputDecoration(labelText: "Grade / Score"),
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
                          widget.onSave({
                            "course-degree": _courseCtrl.text,
                            "from": _fromCtrl.text,
                            "to": _toCtrl.text,
                            "school-university": _schoolCtrl.text,
                            "grade-score": _gradeCtrl.text,
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