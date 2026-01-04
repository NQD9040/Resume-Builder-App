
// template_icon_card.dart
import 'package:flutter/material.dart';

class TemplateIconCard extends StatelessWidget {
  final VoidCallback onTap;
  final String? imagePath;

  const TemplateIconCard({
    super.key,
    required this.onTap,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            color: Colors.grey.shade100,
          ),
          child: Stack(
            children: [
              // Ảnh phủ kín toàn bộ card
              Positioned.fill(
                child: imagePath != null
                    ? Image.asset(
                  imagePath!,
                  fit: BoxFit.cover, // phủ kín
                  errorBuilder: (context, _, __) {
                    return const Center(
                      child: Icon(
                        Icons.description_outlined,
                        size: 64,
                        color: Colors.teal,
                      ),
                    );
                  },
                )
                    : const Center(
                  child: Icon(
                    Icons.description_outlined,
                    size: 64,
                    color: Colors.teal,
                  ),
                ),
              ),
              // Gradient mờ ở dưới để đọc chữ rõ hơn (tuỳ chọn)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.45),
                        Colors.black.withOpacity(0.0),
                      ],
                    ),
                  ),
                  child: const Text(
                    'HTML Template',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(blurRadius: 4, color: Colors.black54, offset: Offset(0, 1)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
