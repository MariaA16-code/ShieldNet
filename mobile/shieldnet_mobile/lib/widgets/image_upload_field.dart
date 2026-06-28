import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../theme.dart';

class ImageUploadField extends StatelessWidget {
  final String label;
  final File? file;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  const ImageUploadField({
    super.key,
    required this.label,
    required this.file,
    required this.onPick,
    required this.onRemove,
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
                    file != null
                        ? file!.path.split(Platform.pathSeparator).last
                        : 'Tap to choose an image',
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

Future<File?> pickImageFile() async {
  final result = await FilePicker.platform.pickFiles(type: FileType.image);
  if (result == null || result.files.single.path == null) return null;
  return File(result.files.single.path!);
}