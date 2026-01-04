import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:printing/printing.dart';

class TemplatePreviewScreen extends StatefulWidget {
  final String assetPath;

  const TemplatePreviewScreen({super.key, required this.assetPath});

  @override
  State<TemplatePreviewScreen> createState() => _TemplatePreviewScreenState();
}

class _TemplatePreviewScreenState extends State<TemplatePreviewScreen> {
  late final WebViewController _controller;
  String _html = '';

  @override
  void initState() {
    super.initState();
    _loadHtml();
  }

  Future<void> _loadHtml() async {
    _html = await rootBundle.loadString(widget.assetPath);

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(_html);

    setState(() {});
  }

  Future<void> _printPdf() async {
    await Printing.layoutPdf(
      onLayout: (format) async {
        final pdf = await Printing.convertHtml(
          html: _html,
          format: format,
        );
        return pdf;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CV Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _printPdf,
            tooltip: 'Download / Print PDF',
          ),
        ],
      ),
      body: _html.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : WebViewWidget(controller: _controller),
    );
  }
}