import 'package:flutter/material.dart';

class EducationForm extends StatefulWidget {
  final Map<String, dynamic>? data;
  final Function(Map<String, dynamic>) onSave;

  const EducationForm({
    super.key,
    this.data,
    required this.onSave,
  });

  @override
  State<EducationForm> createState() => _EducationFormState();
}

class _EducationFormState extends State<EducationForm> {
  final _courseCtrl = TextEditingController();
  final _fromCtrl = TextEditingController();
  final _toCtrl = TextEditingController();
  final _schoolCtrl = TextEditingController();
  final _gradeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.data != null) {
      _courseCtrl.text = widget.data!["course-degree"] ?? "";
      _fromCtrl.text = widget.data!["from"] ?? "";
      _toCtrl.text = widget.data!["to"] ?? "";
      _schoolCtrl.text = widget.data!["school-university"] ?? "";
      _gradeCtrl.text = widget.data!["grade-score"] ?? "";
    }
  }

  @override
  void dispose() {
    _courseCtrl.dispose();
    _fromCtrl.dispose();
    _toCtrl.dispose();
    _schoolCtrl.dispose();
    _gradeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Education Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _courseCtrl,
              decoration:
              const InputDecoration(labelText: "Course / Degree"),
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
              decoration:
              const InputDecoration(labelText: "School / University"),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _gradeCtrl,
              decoration:
              const InputDecoration(labelText: "Grade / Score"),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
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
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
