import 'package:flutter/material.dart';

class ChatItem extends StatefulWidget {
  final String content;
  final String time;
  final bool isCurrent;

  const ChatItem({super.key, required this.content, required this.time, this.isCurrent = false});

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  bool isHovered = false;
  bool isEditHovered = false;
  bool isDeleteHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 25.0, 10.0),
        decoration: BoxDecoration(
          color: isHovered ? Colors.purple[50] : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(right: 150.0),
              child: Row(
                children: [
                  if (widget.isCurrent)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      margin: EdgeInsets.only(right: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        color: Colors.black,
                      ),
                      child: Text("Current Chat", style: TextStyle(color: Colors.yellow)),
                    ),
                  Expanded(
                      child: Text(
                        widget.content,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                        overflow: TextOverflow.ellipsis,
                      ),
                  )
                ],
              )
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.time,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Row(
                  children: [
                    Tooltip(
                      message: "Edit",
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (_) => setState(() => isEditHovered = true),
                        onExit: (_) => setState(() => isEditHovered = false),
                        child: Icon(
                          Icons.edit,
                          color: isEditHovered ? Colors.blue : Colors.grey,
                          size: 25,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Tooltip(
                      message: "Delete",
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click, // Change cursor on hover
                        onEnter: (_) => setState(() => isDeleteHovered = true),
                        onExit: (_) => setState(() => isDeleteHovered = false),
                        child: Icon(
                          Icons.delete_forever,
                          color: isDeleteHovered ? Colors.red : Colors.red[200],
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
