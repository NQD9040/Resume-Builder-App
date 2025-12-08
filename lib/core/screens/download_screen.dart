import "package:flutter/material.dart";

class DownloadScreen extends StatelessWidget {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Download Screen',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            );
          },
        ),
      ),
      body: Text('This is download CV screen'),
    );
  }
}