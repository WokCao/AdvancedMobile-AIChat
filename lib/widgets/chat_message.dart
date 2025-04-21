import 'package:ai_chat/widgets/typing_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

enum MessageType {
  user,
  ai,
}

class ChatMessage {
  final String id;
  final String message;
  final MessageType type;
  final String? senderName;
  final IconData? senderIcon;
  final Color? iconColor;

  ChatMessage({
    required this.id,
    required this.message,
    required this.type,
    this.senderName,
    this.senderIcon,
    this.iconColor,
  });
}

class ChatMessageWidget extends StatefulWidget {
  final ChatMessage message;
  final Function(String id, String newMessage)? onEditMessage;

  const ChatMessageWidget({
    super.key,
    required this.message,
    this.onEditMessage,
  });

  @override
  State<ChatMessageWidget> createState() => _ChatMessageWidgetState();
}

class _ChatMessageWidgetState extends State<ChatMessageWidget> {
  bool _isHovering = false;
  bool _isEditing = false;
  final TextEditingController _editController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _editController.text = widget.message.message;
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  void _copyMessage() {
    Clipboard.setData(ClipboardData(text: widget.message.message));

    // Show a SnackBar to confirm copy
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
      _editController.text = widget.message.message;
    });
  }

  void _saveEdit() {
    if (_editController.text.trim().isNotEmpty) {
      widget.onEditMessage?.call(widget.message.id, _editController.text);
      setState(() {
        _isEditing = false;
      });
    }
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _editController.text = widget.message.message;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isUser = widget.message.type == MessageType.user;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Message Header
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    widget.message.senderIcon ?? Icons.person,
                    size: 16,
                    color: widget.message.iconColor ?? Colors.grey.shade700,
                  ),
                ),
                Text(
                  widget.message.senderName ?? 'You',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),

            // Message Content
            Padding(
              padding: EdgeInsets.only(left: 24.0, top: 4.0),
              child: widget.message.message == 'Typing...' && widget.message.type == MessageType.ai
                ? TypingIndicatorBubble()
                : (_isEditing
                    ? _buildEditField()
                    : MarkdownBody(
                        data: widget.message.message,
                        selectable: true,
                        styleSheet: MarkdownStyleSheet(
                          p: const TextStyle(fontSize: 15, height: 1.5),
                          h3: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          code: TextStyle(fontFamily: 'monospace', backgroundColor: Colors.purple.shade50),
                          strong: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTapLink: (text, href, title) {
                          // Handle link tap
                        },
                      )
                  ),
            ),

            // Action buttons
            Padding(
              padding: EdgeInsets.only(left: 8.0, top: 4.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isEditing) ...[
                    const SizedBox(width: 12),
                    // Copy button
                    AnimatedOpacity(
                      opacity: _isHovering ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 0),
                      child: IconButton(
                        icon: const Icon(Icons.copy, size: 16),
                        onPressed: _isHovering ? _copyMessage : null,
                        tooltip: 'Copy',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 24,
                          minHeight: 24,
                        ),
                        color: Colors.grey.shade500,
                        splashRadius: 16,
                      )
                    ),

                    // Edit button (only for user messages)
                    if (isUser && widget.onEditMessage != null) ...[
                      const SizedBox(width: 4),
                      AnimatedOpacity(
                        opacity: _isHovering ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 0),
                        child: IconButton(
                          icon: const Icon(Icons.edit, size: 16),
                          onPressed: _isHovering ? _startEditing : null,
                          tooltip: 'Edit message',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 24,
                            minHeight: 24,
                          ),
                          color: Colors.grey.shade500,
                          splashRadius: 16,
                        )
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _editController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
          maxLines: null,
          autofocus: true,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade800,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: _cancelEdit,
              style: TextButton.styleFrom(
                backgroundColor: Colors.purple.shade50, // Background color for TextButton
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
                foregroundColor: Colors.black,
              ),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: _saveEdit,
              style: TextButton.styleFrom(
                backgroundColor: Colors.purple.shade300, // Background color for TextButton
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
                foregroundColor: Colors.white,
              ),
              child: const Text('Save changes'),
            ),
          ],
        ),
      ],
    );
  }
}