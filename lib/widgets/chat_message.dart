import 'package:flutter/material.dart';

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

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  message.senderIcon ?? Icons.person,
                  size: 16,
                  color: message.iconColor ?? Colors.grey.shade700,
                ),
              ),
              Text(
                message.senderName ?? 'You',
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
            child: _buildFormattedMessage(message.message),
          ),
        ],
      ),
    );
  }

  Widget _buildFormattedMessage(String text) {
    // Check if the message contains a multi-line code block
    if (text.contains('```')) {
      return _buildMessageWithCodeBlocks(text);
    }

    // Check if the message contains inline code
    if (text.contains('`')) {
      return _buildMessageWithInlineCode(text);
    }

    // Regular text message
    return Text(
      text,
      style: TextStyle(
        fontSize: 15,
        color: Colors.grey.shade800,
        height: 1.5,
      ),
    );
  }

  Widget _buildMessageWithInlineCode(String text) {
    final List<InlineSpan> spans = [];
    final RegExp inlineCodeRegex = RegExp(r'`([^`]+)`');

    int lastMatchEnd = 0;

    // Find all inline code matches
    for (final match in inlineCodeRegex.allMatches(text)) {
      // Add text before the match
      if (match.start > lastMatchEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade800,
              height: 1.5,
            ),
          ),
        );
      }

      // Add the inline code
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
            margin: const EdgeInsets.symmetric(horizontal: 2.0),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              match.group(1) ?? '', // The code without backticks
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'monospace',
                letterSpacing: -0.5,
              ),
            ),
          ),
        ),
      );

      lastMatchEnd = match.end;
    }

    // Add any remaining text
    if (lastMatchEnd < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastMatchEnd),
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade800,
            height: 1.5,
          ),
        ),
      );
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }

  Widget _buildMessageWithCodeBlocks(String text) {
    final List<Widget> widgets = [];
    final RegExp codeBlockRegex = RegExp(r'```(?:(\w+)\n)?([^`]+)```', dotAll: true);

    int lastMatchEnd = 0;

    // Find all code block matches
    for (final match in codeBlockRegex.allMatches(text)) {
      // Add text before the match
      if (match.start > lastMatchEnd) {
        final beforeText = text.substring(lastMatchEnd, match.start);
        widgets.add(
          _buildMessageWithInlineCode(beforeText),
        );
      }

      // Get language (if specified) and code
      final language = match.group(1) ?? '';
      final code = match.group(2) ?? '';

      // Add the code block
      widgets.add(
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (language.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    language,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              Text(
                code.trim(),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontFamily: 'monospace',
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      );

      lastMatchEnd = match.end;
    }

    // Add any remaining text
    if (lastMatchEnd < text.length) {
      final afterText = text.substring(lastMatchEnd);
      widgets.add(
        _buildMessageWithInlineCode(afterText),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}