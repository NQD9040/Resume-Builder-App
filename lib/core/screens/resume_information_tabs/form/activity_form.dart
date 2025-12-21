import 'package:flutter/material.dart';

class ActivityForm extends StatefulWidget {
  final Map<String, dynamic>? data;
  final Function(Map<String, dynamic>) onSave;

  const ActivityForm({super.key, this.data, required this.onSave});

  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  final _organizationCtrl = TextEditingController();
  final _fromCtrl = TextEditingController();
  final _toCtrl = TextEditingController();
  final _roleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Khởi tạo các text field thông thường
    if (widget.data != null) {
      _organizationCtrl.text = widget.data!["organization-name"] ?? "";
      _fromCtrl.text = widget.data!["from"] ?? "";
      _toCtrl.text = widget.data!["to"] ?? "";
      _roleCtrl.text = widget.data!["role"] ?? "";
      _descriptionCtrl.text = widget.data!["description"] ?? "";
    }
  }

  @override
  void dispose() {
    _organizationCtrl.dispose();
    _fromCtrl.dispose();
    _toCtrl.dispose();
    _roleCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Activity Details"),
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
                      controller: _organizationCtrl,
                      decoration: const InputDecoration(labelText: "Organization Name"),
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

                    const SizedBox(height: 20),

                    TextField(
                      controller: _descriptionCtrl,
                      decoration: const InputDecoration(labelText: "Description"),
                    ),

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
                            "organization-name": _organizationCtrl.text,
                            "from": _fromCtrl.text,
                            "to": _toCtrl.text,
                            "role": _roleCtrl.text,
                            "description": _descriptionCtrl.text,
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