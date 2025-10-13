import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

// import 'package:pro_image_editor/pro_image_editor.dart'; // full editor
import 'package:image_cropper/image_cropper.dart'; //crop only

enum EditMode { full, cropOnly, none }

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  /// Shows gallery/camera sheet, then optional editor, returns the final image File (or null).
  static Future<File?> pickImageWithSheet(
    BuildContext context, {
    double? maxWidth = 1024,
    int? imageQuality = 85,
    EditMode editMode = EditMode.full, // ⬅ default to full editor
  }) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => const _PickSheet(),
    );
    if (source == null) return null;

    try {
      final XFile? x = await _picker.pickImage(
        source: source,
        maxWidth: maxWidth,
        imageQuality: imageQuality,
      );
      if (x == null) return null;

      // If no editing requested, return as-is.
      if (editMode == EditMode.none) return File(x.path);

      // ---- Full editor path (WhatsApp-like) ----
      // if (editMode == EditMode.full) {
      //   final bytes = await File(x.path).readAsBytes();
      //
      //   // Push the editor page and wait for edited bytes.
      //   final Uint8List? edited = await Navigator.of(context).push(
      //     MaterialPageRoute(
      //       builder: (_) => ProImageEditor.memory(
      //         bytes,
      //         callbacks: ProImageEditorCallbacks(
      //           onImageEditingComplete: (Uint8List editedBytes) {
      //             Navigator.of(context).pop(editedBytes);
      //             return Future.value(); // ⬅ satisfy Future<void>
      //           },
      //           // onCloseEditor: (EditorMode mode) {
      //           //   // Called when user closes editor — mode tells how it was closed.
      //           //   // Example: EditorMode.view, EditorMode.edit
      //           //   Navigator.of(context).pop(null);
      //           // },
      //         ),
      //       ),
      //     ),
      //   );
      //
      //   if (edited == null) return null;
      //
      //   // Persist edited bytes to a temp file so your avatar can use FileImage.
      //   final temp = await _writeTempImage(edited, ext: _extFromPath(x.path));
      //   return temp;
      // }

      // ---- Crop-only path ----
      // If you prefer a native cropper UI (simple & fast).
      // Requires: image_cropper in pubspec + platform configs.

      if (editMode == EditMode.cropOnly) {
        final CroppedFile? cropped = await ImageCropper().cropImage(
          sourcePath: x.path,

          // Force square
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),

          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Edit photo',
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true,        // 🔒 fixes it to 1:1
              hideBottomControls: false,    // optional
            ),
            IOSUiSettings(
              title: 'Edit photo',
              aspectRatioLockEnabled: true, // 🔒 fixes it to 1:1
              resetAspectRatioEnabled: false, // optional: prevents unlocking
            ),
          ],
        );

        if (cropped == null) return null;
        return File(cropped.path);
      }
      // if (editMode == EditMode.cropOnly) {
      //   final CroppedFile? cropped = await ImageCropper().cropImage(
      //     sourcePath: x.path,
      //     uiSettings: [
      //       AndroidUiSettings(
      //         toolbarTitle: 'Edit photo',
      //         hideBottomControls: false,
      //         lockAspectRatio: false,
      //       ),
      //       IOSUiSettings(title: 'Edit photo'),
      //     ],
      //   );
      //   if (cropped == null) return null;
      //   return File(cropped.path);
      // }

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

  static Future<File> _writeTempImage(
    Uint8List bytes, {
    String ext = 'jpg',
  }) async {
    final dir = await Directory.systemTemp.createTemp('avatar_edit_');
    final file = File('${dir.path}/edited.$ext');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  static String _extFromPath(String path) {
    final i = path.lastIndexOf('.');
    final raw = (i == -1) ? 'jpg' : path.substring(i + 1).toLowerCase();
    // normalize common cases
    return (raw == 'jpeg') ? 'jpg' : raw;
  }
}

class _PickSheet extends StatelessWidget {
  const _PickSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          _PickTile(
            icon: Icons.photo_library,
            label: 'Choose from gallery',
            source: ImageSource.gallery,
          ),
          _PickTile(
            icon: Icons.photo_camera,
            label: 'Take a photo',
            source: ImageSource.camera,
          ),
        ],
      ),
    );
  }
}

class _PickTile extends StatelessWidget {
  const _PickTile({
    required this.icon,
    required this.label,
    required this.source,
  });
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
