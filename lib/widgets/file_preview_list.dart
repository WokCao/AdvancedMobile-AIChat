import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'file_preview.dart';

class FilePreviewList extends StatelessWidget {
  final List<PlatformFile>? files;
  final List<String>? fileUrls;
  final void Function(int index)? onRemove;
  final double size;

  const FilePreviewList({
    super.key,
    this.files,
    this.fileUrls,
    this.onRemove,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    final count = files?.length ?? fileUrls?.length ?? 0;

    if (count == 0) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List.generate(
          files?.length ?? fileUrls?.length ?? 0,
              (index) {
            if (files != null) {
              return FilePreview(
                file: files![index],
                onRemove: onRemove != null ? () => onRemove!(index) : null,
                size: size,
              );
            } else {
              return FilePreview(
                url: fileUrls![index],
                size: size,
              );
            }
          },
        ),
      ),
    );
  }
}
