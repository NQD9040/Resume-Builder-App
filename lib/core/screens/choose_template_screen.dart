import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/template_icon_card.dart';
import 'template_preview_screen.dart';

class ChooseTemplateScreen extends StatefulWidget {
  const ChooseTemplateScreen({super.key});

  @override
  State<ChooseTemplateScreen> createState() => _ChooseTemplateScreenState();
}

class _ChooseTemplateScreenState extends State<ChooseTemplateScreen> {
  List<String> _htmlFiles = [];

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  Future<void> _loadTemplates() async {
    final manifest =
    json.decode(await rootBundle.loadString('AssetManifest.json'))
    as Map<String, dynamic>;

    final files = manifest.keys
        .where((e) =>
    e.startsWith('assets/samples/') && e.endsWith('.html'))
        .toList();

    setState(() {
      _htmlFiles = files;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Choose Template',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: _htmlFiles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _htmlFiles.length,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.65,
        ),
        itemBuilder: (context, index) {
          final path = _htmlFiles[index];

          return Column(
            children: [
              Expanded(
                child: TemplateIconCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TemplatePreviewScreen(
                          assetPath: path,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Template ${index + 1}',
                style: const TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
