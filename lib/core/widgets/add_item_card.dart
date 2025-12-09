import 'package:flutter/material.dart';

class AddItemCard extends StatelessWidget {
  final String title;
  final VoidCallback onAdd;

  const AddItemCard({
    super.key,
    required this.title,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Tap + icon to create $title details",
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onAdd,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 32),
          ),
        ),
      ],
    );
  }
}
