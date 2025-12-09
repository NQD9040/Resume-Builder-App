import 'package:flutter/material.dart';

class AppUtils {
  /// 📌 Confirm dialog dùng chung
  static Future<bool> confirmDelete(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Entry"),
        content: const Text("Are you sure you want to delete this information ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Yes",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
  static Future<bool> confirmExit(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Exit app?"),
          content: const Text("Are you sure you want to exit?"),
          actions: [
            TextButton(
              child: const Text("No"),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );

    return result == true;
  }
}
