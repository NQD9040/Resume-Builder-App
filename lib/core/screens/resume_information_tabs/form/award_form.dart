import 'package:flutter/material.dart';

class AwardForm extends StatefulWidget {
  final Map<String, dynamic>? data;
  final Function(Map<String, dynamic>) onSave;

  const AwardForm({super.key, this.data, required this.onSave});

  @override
  State<AwardForm> createState() => _AwardFormState();
}

class _AwardFormState extends State<AwardForm> {
  final _awardCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();
  final _detailCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Khởi tạo các text field thông thường
    if (widget.data != null) {
      _awardCtrl.text = widget.data!["award-name"] ?? "";
      _yearCtrl.text = widget.data!["year"] ?? "";
      _detailCtrl.text = widget.data!["detail"] ?? "";
    }
  }

  @override
  void dispose() {
    _awardCtrl.dispose();
    _yearCtrl.dispose();
    _detailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Award Details"),
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
                      controller: _awardCtrl,
                      decoration: const InputDecoration(labelText: "Name of Award or Achievement"),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: _yearCtrl,
                      decoration: const InputDecoration(labelText: "Year"),
                    ),

                    const SizedBox(height: 20),
                    TextField(
                      controller: _detailCtrl,
                      decoration: const InputDecoration(labelText: "Details"),
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
                            "award-name": _awardCtrl.text,
                            "year": _yearCtrl.text,
                            "detail": _detailCtrl.text,
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