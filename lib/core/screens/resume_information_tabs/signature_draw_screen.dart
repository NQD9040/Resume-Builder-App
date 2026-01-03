import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/rendering.dart';

class SignatureDrawScreen extends StatefulWidget {
  const SignatureDrawScreen({super.key});

  @override
  State<SignatureDrawScreen> createState() => _SignatureDrawScreenState();
}

class _SignatureDrawScreenState extends State<SignatureDrawScreen> {
  final List<Offset?> _points = [];
  final GlobalKey _paintKey = GlobalKey();

  /// ===== SAVE SIGNATURE =====
  Future<void> _saveSignature() async {
    if (_points.isEmpty) return;

    final boundary =
    _paintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    final image = await boundary.toImage(pixelRatio: 3);
    final byteData =
    await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) return;

    final pngBytes = byteData.buffer.asUint8List();

    final dir = await getApplicationDocumentsDirectory();
    final sigDir = Directory(p.join(dir.path, 'signatures'));
    if (!sigDir.existsSync()) {
      sigDir.createSync(recursive: true);
    }

    final file = File(
      p.join(
        sigDir.path,
        'signature_${DateTime.now().millisecondsSinceEpoch}.png',
      ),
    );

    await file.writeAsBytes(pngBytes);

    Navigator.pop(context, file.path);
  }

  void _clear() {
    setState(() {
      _points.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Draw Signature"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _clear,
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveSignature,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RepaintBoundary(
              key: _paintKey,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _points.add(details.localPosition);
                  });
                },
                onPanEnd: (_) => _points.add(null),
                child: CustomPaint(
                  painter: _SignaturePainter(_points),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              "Draw your signature above",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignaturePainter extends CustomPainter {
  final List<Offset?> points;

  _SignaturePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
