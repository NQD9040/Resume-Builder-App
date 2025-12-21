import 'package:flutter/material.dart';

class ReferenceForm extends StatefulWidget {
  final Map<String, dynamic>? data;
  final Function(Map<String, dynamic>) onSave;

  const ReferenceForm({super.key, this.data, required this.onSave});

  @override
  State<ReferenceForm> createState() => _ReferenceFormState();
}

class _ReferenceFormState extends State<ReferenceForm> {
  final _nameCtrl = TextEditingController();
  final _jobCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Khởi tạo các text field thông thường
    if (widget.data != null) {
      _nameCtrl.text = widget.data!["name"] ?? "";
      _jobCtrl.text = widget.data!["job-title"] ?? "";
      _companyCtrl.text = widget.data!["company-name"] ?? "";
      _emailCtrl.text = widget.data!["email"] ?? "";
      _phoneCtrl.text = widget.data!["phone"] ?? "";
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _jobCtrl.dispose();
    _companyCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Reference Details"),
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
                      controller: _nameCtrl,
                      decoration: const InputDecoration(labelText: "Name"),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: _jobCtrl,
                      decoration:
                          const InputDecoration(labelText: "Job Title"),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: _companyCtrl,
                      decoration:
                          const InputDecoration(labelText: "Company Name"),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: _emailCtrl,
                      decoration: const InputDecoration(labelText: "Email"),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: _phoneCtrl,
                      decoration: const InputDecoration(labelText: "Phone"),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 24),

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
                            "name": _nameCtrl.text.trim(),
                            "job-title": _jobCtrl.text.trim(),
                            "company-name": _companyCtrl.text.trim(),
                            "email": _emailCtrl.text.trim(),
                            "phone": _phoneCtrl.text.trim(),
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