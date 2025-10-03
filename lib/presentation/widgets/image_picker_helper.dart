import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  /// Shows a bottom sheet (gallery / camera) and returns a File, or null if canceled.
  static Future<File?> pickImageWithSheet(
      BuildContext context, {
        double? maxWidth = 1024,
        int? imageQuality = 85,
        bool allowEdit = true,
      }) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            _PickTile(icon: Icons.photo_library, label: 'Choose from gallery', source: ImageSource.gallery),
            _PickTile(icon: Icons.photo_camera,  label: 'Take a photo',        source: ImageSource.camera),
          ],
        ),
      ),
    );
    if (source == null) return null;

    try {
      final XFile? x = await _picker.pickImage(
        source: source,
        maxWidth: maxWidth,
        imageQuality: imageQuality,
      );
      if (x == null) return null;
      return File(x.path);
    } on PlatformException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Failed to pick image')),
        );
      }
      return null;
    }
  }
}

class _PickTile extends StatelessWidget {
  const _PickTile({required this.icon, required this.label, required this.source});
  final IconData icon;
  final String label;
  final ImageSource source;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () => Navigator.pop(context, source),
    );
  }
}
