import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../services/resume_storage.dart';
import 'signature_draw_screen.dart';

class PhotoSignInformationScreen extends StatefulWidget {
  final Map<String, dynamic> resume;

  const PhotoSignInformationScreen({
    super.key,
    required this.resume,
  });

  @override
  State<PhotoSignInformationScreen> createState() =>
      _PhotoSignInformationScreenState();
}

class _PhotoSignInformationScreenState
    extends State<PhotoSignInformationScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  File? _photoFile;
  File? _signatureFile;

  @override
  void initState() {
    super.initState();
    _loadPhoto();
    _loadSignature();
  }

  /// ===== LOAD PHOTO =====
  Future<void> _loadPhoto() async {
    final path = await ResumeStorage.loadData(
      resume: widget.resume,
      key: 'photo',
    );

    if (path is String && File(path).existsSync()) {
      setState(() {
        _photoFile = File(path);
      });
    }
  }

  /// ===== LOAD SIGNATURE =====
  Future<void> _loadSignature() async {
    final path = await ResumeStorage.loadData(
      resume: widget.resume,
      key: 'signature',
    );

    if (path is String && File(path).existsSync()) {
      setState(() {
        _signatureFile = File(path);
      });
    }
  }

  /// ===== PICK PHOTO =====
  Future<void> _addPhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text("Gallery"),
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Camera"),
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
        ],
      ),
    );

    if (source == null) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 100,
    );
    if (picked == null) return;

    final cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 4),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Photo',
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          aspectRatioLockEnabled: true,
        ),
      ],
    );

    if (cropped == null) return;

    final dir = await getApplicationDocumentsDirectory();
    final photoDir = Directory(p.join(dir.path, 'photos'));
    if (!photoDir.existsSync()) {
      photoDir.createSync(recursive: true);
    }

    final fileName =
        'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final savedFile = File(p.join(photoDir.path, fileName));
    await File(cropped.path).copy(savedFile.path);

    await ResumeStorage.saveData(
      resume: widget.resume,
      key: 'photo',
      value: savedFile.path,
    );

    setState(() {
      _photoFile = savedFile;
    });
  }

  /// ===== REMOVE PHOTO =====
  Future<void> _removePhoto() async {
    if (_photoFile != null && _photoFile!.existsSync()) {
      await _photoFile!.delete();
    }

    await ResumeStorage.saveData(
      resume: widget.resume,
      key: 'photo',
      value: null,
    );

    setState(() {
      _photoFile = null;
    });
  }

  /// ===== ADD SIGNATURE =====
  Future<void> _addSignature() async {
    final path = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => const SignatureDrawScreen(),
      ),
    );

    if (path == null) return;

    await ResumeStorage.saveData(
      resume: widget.resume,
      key: 'signature',
      value: path,
    );

    setState(() {
      _signatureFile = File(path);
    });
  }

  /// ===== REMOVE SIGNATURE =====
  Future<void> _removeSignature() async {
    if (_signatureFile != null && _signatureFile!.existsSync()) {
      await _signatureFile!.delete();
    }

    await ResumeStorage.saveData(
      resume: widget.resume,
      key: 'signature',
      value: null,
    );

    setState(() {
      _signatureFile = null;
    });
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
              /// ===== PHOTO =====
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
                    backgroundImage: _photoFile != null
                        ? FileImage(_photoFile!)
                        : const AssetImage("assets/images/contact_us.png")
                    as ImageProvider,
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

              /// ===== SIGNATURE =====
              const Text(
                "Signature",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),

              GestureDetector(
                onTap: _addSignature,
                child: Container(
                  width: 160,
                  height: 80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _signatureFile != null
                      ? Image.file(_signatureFile!, fit: BoxFit.contain)
                      : const Text(
                    "Tap to sign",
                    style: TextStyle(color: Colors.grey),
                  ),
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
