import 'package:flutter/material.dart';

class ContactInformationScreen extends StatefulWidget {
  final Map<String, dynamic> resume;
  final VoidCallback onSave;

  const ContactInformationScreen({
    super.key,
    required this.resume,
    required this.onSave,
  });

  @override
  State<ContactInformationScreen> createState() =>
      _ContactInformationScreenState();
}

class _ContactInformationScreenState extends State<ContactInformationScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final data = widget.resume["data"];
    if (data == null) return;

    final contact = data["contact"];
    if (contact == null) return;

    _nameController.text = contact["name"]?.toString() ?? "";
    _addressController.text = contact["address"]?.toString() ?? "";
    _phoneController.text = contact["phone"]?.toString() ?? "";
    _emailController.text = contact["email"]?.toString() ?? "";
  }


  InputDecoration _inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.teal, width: 2),
      ),
      contentPadding:
      const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
    );
  }

  void _saveContact() {
    widget.resume["data"] ??= {};

    widget.resume["data"]["contact"] = {
      "name": _nameController.text.trim(),
      "address": _addressController.text.trim(),
      "phone": _phoneController.text.trim(),
      "email": _emailController.text.trim(),
    };

    widget.onSave(); // báo ResumeInformationScreen save file

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Contact saved")),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: _inputStyle("Name"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _addressController,
              decoration: _inputStyle("Address"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: _inputStyle("Phone Number"),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: _inputStyle("Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _saveContact,
                child: const Text(
                  "SAVE",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
