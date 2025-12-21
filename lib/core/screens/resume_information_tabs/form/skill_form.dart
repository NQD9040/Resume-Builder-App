import 'package:flutter/material.dart';

class SkillForm extends StatefulWidget {
  final Map<String, dynamic>? data;
  final Function(Map<String, dynamic>) onSave;

  const SkillForm({
    super.key,
    this.data,
    required this.onSave,
  });

  @override
  State<SkillForm> createState() => _SkillFormState();
}

class _SkillFormState extends State<SkillForm> {
  final _nameController = TextEditingController();
  int _rating = 0;

  @override
  void initState() {
    super.initState();

    // Nếu có data truyền vào → fill lại form
    if (widget.data != null) {
      _nameController.text = widget.data!["name"] ?? "";
      _rating = widget.data!["rating"] ?? 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Skill Details"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // INPUT SKILL NAME
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Skill Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // STAR SELECTOR
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (idx) {
                return IconButton(
                  icon: Icon(
                    idx < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 32,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = idx + 1; // chọn sao
                    });
                  },
                );
              }),
            ),

            const SizedBox(height: 30),

            // SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  final name = _nameController.text.trim();

                  if (name.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Skill name cannot be empty"),
                      ),
                    );
                    return;
                  }

                  widget.onSave({
                    "name": name,
                    "rating": _rating,
                  });

                  Navigator.pop(context);
                },
                child: const Text("SAVE"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
