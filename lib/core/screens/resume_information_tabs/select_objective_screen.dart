import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xml/xml.dart';

class SelectObjectiveScreen extends StatefulWidget {
  const SelectObjectiveScreen({super.key});

  @override
  State<SelectObjectiveScreen> createState() => _SelectObjectiveScreenState();
}

class _SelectObjectiveScreenState extends State<SelectObjectiveScreen> {
  List<String> objectives = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadObjectives();
  }

  Future<void> _loadObjectives() async {
    final rawXml = await rootBundle.loadString('assets/array.xml');
    final document = XmlDocument.parse(rawXml);

    final items = document
        .findAllElements('string-array')
        .where((e) => e.getAttribute('name') == 'objective_array')
        .expand((e) => e.findElements('item'))
        .map((e) => e.text.trim())
        .toList();

    setState(() {
      objectives = items;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Select Sample'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: objectives.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final text = objectives[index];

          return InkWell(
            onTap: () {
              Navigator.pop(context, text);
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                text,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          );
        },
      ),
    );
  }
}
