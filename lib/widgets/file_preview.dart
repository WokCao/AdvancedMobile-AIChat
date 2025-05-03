import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FilePreview extends StatelessWidget {
  final String? url;
  final PlatformFile? file;
  final VoidCallback? onRemove;
  final double size;

  const FilePreview({
    super.key,
    this.url,
    this.file,
    this.onRemove,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    late String? ext;
    if (file != null) {
      ext = file!.extension?.toLowerCase();
    }
    if (url != null) {
      ext = url!.toLowerCase().split('.').last;
    }

    bool isImage = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'svg'].contains(ext);

    late Image? img;
    if (isImage) {
      if (file != null && file!.bytes != null) {
        img = Image.memory(file!.bytes!, width: size, height: size, fit: BoxFit.cover);
      } else if (url != null) {
        img = Image.network(url!, width: size, height: size, fit: BoxFit.cover);
      }
    }

    final fileName = file?.name ?? url?.split('/').last ?? 'Unknown file';

    return Stack(
      children: [
        isImage ? img! : _fileCard(Icons.description, fileName),
        if (onRemove != null) _buildRemoveButton(),
      ],
    );
  }

  Widget _fileCard(IconData icon, String label) {
    return InkWell(
      onTap: () => {
        if (url != null) launchUrl(Uri.parse(url!))
      },
      child: Container(
        width: size + 60,
        padding: EdgeInsets.only(top: 12, left: 12, bottom: 12, right: onRemove != null ? 28 : 12),
        decoration: BoxDecoration(
          color: Colors.purple.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.purple),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 10),
            Expanded(
              child: Text(label, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemoveButton() {
    return Positioned(
      top: 4,
      right: 4,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onRemove,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black54,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(4),
            child: const Icon(Icons.close, color: Colors.white, size: 16),
          ),
        ),
      ),
    );
  }
}
