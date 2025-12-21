import 'package:flutter/material.dart';

class CoverLetterInformationScreen extends StatefulWidget {
  const CoverLetterInformationScreen({super.key});

  @override
  State<CoverLetterInformationScreen> createState() =>
      _CoverLetterInformationScreenState();
}

class _CoverLetterInformationScreenState
    extends State<CoverLetterInformationScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _letterController = TextEditingController();

  /// ===== PLACEHOLDER FUNCTIONS =====
  void _selectLetter() {
    // TODO: chọn cover letter mẫu
  }

  void _clearLetter() {
    _letterController.clear();
  }

  void _saveLetter() {
    final content = _letterController.text;
    Navigator.pop(context, content);
  }

  @override
  void dispose() {
    _letterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// ===== TEXT AREA =====
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.teal),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _letterController,
                keyboardType: TextInputType.multiline,
                minLines: 1,        // ban đầu 1 dòng
                maxLines: null,     // gõ nhiều thì tự nở
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Write your cover letter here...",
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// ===== ACTION BUTTONS =====
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: _selectLetter,
                    icon: const Icon(Icons.upload, color: Colors.white),
                    label: const Text(
                      "Select Letter",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: _clearLetter,
                    icon: const Icon(Icons.close, color: Colors.red),
                    label: const Text(
                      "Clear Letter",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// ===== SAVE =====
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
                onPressed: _saveLetter,
                child: const Text(
                  "SAVE",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
