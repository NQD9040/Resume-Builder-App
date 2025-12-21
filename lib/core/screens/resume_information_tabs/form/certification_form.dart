import 'package:flutter/material.dart';

class CertificationForm extends StatefulWidget {
  final Map<String, dynamic>? data;
  final Function(Map<String, dynamic>) onSave;

  const CertificationForm({super.key, this.data, required this.onSave});

  @override
  State<CertificationForm> createState() => _CertificationFormState();
}

class _CertificationFormState extends State<CertificationForm> {
  final _certificationCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Khởi tạo các text field thông thường
    if (widget.data != null) {
      _certificationCtrl.text = widget.data!["certification-name"] ?? "";
      _yearCtrl.text = widget.data!["year"] ?? "";
    }
  }

  @override
  void dispose() {
    _certificationCtrl.dispose();
    _yearCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Certification Details"),
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
                      controller: _certificationCtrl,
                      decoration: const InputDecoration(labelText: "Certification Name"),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: _yearCtrl,
                      decoration: const InputDecoration(labelText: "Year"),
                    ),

                    const SizedBox(height: 20),

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
                            "certification-name": _certificationCtrl.text,
                            "year": _yearCtrl.text,
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