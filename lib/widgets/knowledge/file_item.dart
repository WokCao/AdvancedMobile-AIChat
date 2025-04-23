import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FileItem extends StatefulWidget {
  final PlatformFile file;
  final Function(PlatformFile) removeFile;
  const FileItem({super.key, required this.file, required this.removeFile});

  @override
  State<FileItem> createState() => _FileItemState();
}

class _FileItemState extends State<FileItem> {
  bool isHovered = false;

  String _getReadableFileSize(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    final i = (bytes != 0) ? (log(bytes) / log(1024)).floor() : 0;
    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: isHovered ? Colors.purple.shade50 : Colors.transparent,
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 72),
                child: Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.paperclip,
                      size: 16,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Tooltip(
                            message: widget.file.name,
                            child: Text(
                              widget.file.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            _getReadableFileSize(widget.file.size),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Tooltip(
              message: "Remove",
              child: GestureDetector(
                onTap: () {
                  widget.removeFile(widget.file);
                },
                child: FaIcon(
                  FontAwesomeIcons.trash,
                  size: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
