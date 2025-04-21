import 'package:ai_chat/widgets/history/edit_chat_title.dart';
import 'package:ai_chat/widgets/history/remove_chat.dart';
import 'package:flutter/material.dart';

class ChatItem extends StatefulWidget {
  final String content;
  final String time;
  final VoidCallback onTap;
  final bool isCurrent;

  const ChatItem({
    super.key,
    required this.content,
    required this.time,
    required this.onTap,
    this.isCurrent = false,
  });

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  bool isHovered = false;
  bool isEditHovered = false;
  bool isDeleteHovered = false;

  void _showEditChatTitle(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditChatTitle(
          title: "Rename Conversation",
          initialValue: widget.content,
          maxLength: 80,
          onSave: (value) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Saved: $value')));
          },
        );
      },
    );
  }

  void _showDeleteChat(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RemoveChat();
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: EdgeInsets.all(10.0),
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
                          color: Colors.purple.shade200,
                        ),
                        child: Text(
                          "Current Chat",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    Expanded(
                      child: Text(
                        widget.content,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
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
                        child: GestureDetector(
                          onTap: () {
                            _showEditChatTitle(context);
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            onEnter: (_) => setState(() => isEditHovered = true),
                            onExit: (_) => setState(() => isEditHovered = false),
                            child: Icon(
                              Icons.edit,
                              color: isEditHovered ? Colors.purple : Colors.grey,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Tooltip(
                        message: "Delete",
                        child: GestureDetector(
                          onTap: () {
                            _showDeleteChat(context);
                          },
                          child: MouseRegion(
                            cursor:
                            SystemMouseCursors.click, // Change cursor on hover
                            onEnter: (_) => setState(() => isDeleteHovered = true),
                            onExit: (_) => setState(() => isDeleteHovered = false),
                            child: Icon(
                              Icons.delete_forever,
                              color: isDeleteHovered ? Colors.purple : Colors.grey,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
