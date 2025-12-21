import 'package:flutter/material.dart';

class PhotoSignInformationScreen extends StatefulWidget {
  const PhotoSignInformationScreen({super.key});

  @override
  State<PhotoSignInformationScreen> createState() =>
      _PhotoSignInformationScreenState();
}

class _PhotoSignInformationScreenState
    extends State<PhotoSignInformationScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void _addPhoto() {
    // TODO
  }

  void _removePhoto() {
    // TODO
  }

  void _removeSignature() {
    // TODO
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// PHOTO
              const Text(
                "Photo",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),

              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundImage: const AssetImage(
                      "assets/images/contact_us.png", // ảnh giả
                    ),
                    backgroundColor: Colors.grey.shade200,
                  ),
                  GestureDetector(
                    onTap: _addPhoto,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.teal,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: 120,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade200,
                  ),
                  onPressed: _removePhoto,
                  child: const Text(
                    "REMOVE",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              /// SIGNATURE
              const Text(
                "Signature",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),

              Container(
                width: 160,
                height: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  "assets/images/contact_us.png", // ảnh giả
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: 120,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade200,
                  ),
                  onPressed: _removeSignature,
                  child: const Text(
                    "REMOVE",
                    style: TextStyle(color: Colors.white),
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
