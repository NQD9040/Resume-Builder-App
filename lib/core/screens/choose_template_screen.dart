
// choose_template_screen.dart
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
  List<String> _pictureFiles = [];

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  Future<void> _loadTemplates() async {
    final manifest = json.decode(
      await rootBundle.loadString('AssetManifest.json'),
    ) as Map<String, dynamic>;

    // Lọc HTML trong assets/samples/
    final htmlFiles = manifest.keys
        .where((e) => e.startsWith('assets/samples/') && e.endsWith('.html'))
        .toList()
      ..sort((a, b) => a.compareTo(b));

    // Lọc ảnh trong assets/samples/pictures/ với nhiều định dạng
    const exts = <String>['.png', '.jpg', '.jpeg', '.gif', '.webp', '.bmp'];
    final picFiles = manifest.keys
        .where((e) =>
    e.startsWith('assets/samples/pictures/') &&
        exts.any((ext) => e.toLowerCase().endsWith(ext)))
        .toList()
      ..sort((a, b) => a.compareTo(b));

    setState(() {
      _htmlFiles = htmlFiles;
      _pictureFiles = picFiles;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _htmlFiles.isEmpty;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Choose Template',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _htmlFiles.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.65,
        ),
        itemBuilder: (context, index) {
          final path = _htmlFiles[index];
          // Lấy ảnh theo thứ tự; nếu thiếu ảnh thì để null (fallback icon)
          final imagePath =
          index < _pictureFiles.length ? _pictureFiles[index] : null;
          print('Using imagePath: $imagePath for template: $path');
          return Column(
            children: [
              Expanded(
                child: TemplateIconCard(
                  imagePath: imagePath, // NEW
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TemplatePreviewScreen(
                          assetPath: path,
                          // TODO: nếu sau này preview cần dữ liệu resume,
                          // truyền thêm đối tượng resume vào đây.
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