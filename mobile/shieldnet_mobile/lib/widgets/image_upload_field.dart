import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../theme.dart';

/// A picked file kept entirely in memory as bytes + a filename.
///
/// Why not `dart:io File`? `File` is backed by a real filesystem path,
/// and `file_picker` only ever returns a usable `.path` on mobile/
/// desktop — on Flutter Web, `.path` is always null by design (browsers
/// don't expose real filesystem paths to JS/Dart for security reasons).
/// `.bytes` is the one property that works identically on every
/// platform, so this app standardizes on bytes everywhere instead of
/// branching the picker logic per platform.
class PickedFile {
  final String name;
  final Uint8List bytes;

  const PickedFile({required this.name, required this.bytes});

  int get sizeInBytes => bytes.length;
}

class ImageUploadField extends StatelessWidget {
  final String label;
  final PickedFile? file;
  final VoidCallback onPick;
  final VoidCallback onRemove;
  final String hint; // e.g. 'Tap to choose a video'

  const ImageUploadField({
    super.key,
    required this.label,
    required this.file,
    required this.onPick,
    required this.onRemove,
    this.hint = 'Tap to choose an image',
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: file == null ? onPick : null,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: file != null ? AppTheme.success : AppTheme.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              file != null ? Icons.check_circle : Icons.upload_file_outlined,
              color: file != null ? AppTheme.success : AppTheme.textSecondary,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    file != null ? file!.name : hint,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 14,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (file != null)
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: onRemove,
                color: AppTheme.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}

/// Opens the system file picker for a single image and returns it as
/// in-memory bytes. `withData: true` is required explicitly — recent
/// file_picker versions default it to `false` on every platform
/// including web, so omitting it silently returns null bytes there.
Future<PickedFile?> pickImageFile() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.image,
    withData: true,
  );
  if (result == null || result.files.isEmpty) return null;
  final picked = result.files.single;
  if (picked.bytes == null) return null;
  return PickedFile(name: picked.name, bytes: picked.bytes!);
}

/// Same as [pickImageFile] but restricted to common video formats, for
/// the Deepfake Video evidence category.
Future<PickedFile?> pickVideoFile() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.video,
    withData: true,
  );
  if (result == null || result.files.isEmpty) return null;
  final picked = result.files.single;
  if (picked.bytes == null) return null;
  return PickedFile(name: picked.name, bytes: picked.bytes!);
}