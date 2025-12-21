import 'package:flutter/material.dart';
import 'package:resume_builder_project/core/screens/choose_template_screen.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final Map<String, bool> options = {
    "1. Contact": true,
    "2. Education": true,
    "3. Experience": true,
    "4. Project": true,
    "5. Skill": true,
    "6. Award": true,
    "7. Activity": true,
    "8. Certification": true,
    "9. Reference": true,
    "10. Objective": true,
    "11. Cover Letter": true,
    "12. Photo - Sign": true,
  };

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),

            const Text(
              "Select Resume Options",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 3.5,
                children: options.keys.map((key) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        options[key] = !(options[key] ?? false);
                      });
                    },
                    child: Row(
                      children: [
                        Checkbox(
                          value: options[key],
                          activeColor: Colors.teal,
                          onChanged: (val) {
                            setState(() {
                              options[key] = val ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            key,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ChooseTemplateScreen()),
                  );
                },
                child: const Text(
                  "EXPORT",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
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
