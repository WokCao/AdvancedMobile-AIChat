import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FileItem extends StatefulWidget {
  final String name;
  const FileItem({super.key, required this.name});

  @override
  State<FileItem> createState() => _FileItemState();
}

class _FileItemState extends State<FileItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: isHovered ? Colors.purple.shade50 : Colors.transparent
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 72),
                child: Row(
                  children: [
                    FaIcon(FontAwesomeIcons.paperclip, size: 16, color: Colors.grey,),
                    SizedBox(width: 12,),
                    Expanded(
                      child: Tooltip(
                        message: widget.name,
                        child: Text(widget.name, overflow: TextOverflow.ellipsis,),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Tooltip(
              message: "Remove",
              child: FaIcon(FontAwesomeIcons.trash, size: 16, color: Colors.grey,),
            )
          ],
        ),
      ),
    );
  }
}

