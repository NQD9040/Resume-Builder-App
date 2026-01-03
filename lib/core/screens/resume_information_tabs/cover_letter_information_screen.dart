import 'package:flutter/material.dart';
import '../../services/resume_storage.dart';

class CoverLetterInformationScreen extends StatefulWidget {
  final Map<String, dynamic> resume;

  const CoverLetterInformationScreen({
    super.key,
    required this.resume,
  });

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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// ===== LOAD DATA =====
  Future<void> _loadData() async {
    final data = await ResumeStorage.loadData(
      resume: widget.resume,
      key: 'coverLetter',
    );

    if (data is String && data.isNotEmpty) {
      _letterController.text = data;
    }
  }

  /// ===== SAVE DATA =====
  Future<void> _saveData() async {
    await ResumeStorage.saveData(
      resume: widget.resume,
      key: 'coverLetter',
      value: _letterController.text,
    );
  }

  /// ===== SELECT LETTER (CHƯA LÀM) =====
  void _selectLetter() {
    // TODO: chọn cover letter mẫu
  }

  /// ===== CLEAR =====
  void _clearLetter() {
    _letterController.clear();
    _saveData();
  }

  /// ===== SAVE (KHÔNG POP) =====
  void _saveLetter() {
    _saveData();
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
                minLines: 1,
                maxLines: null,
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
