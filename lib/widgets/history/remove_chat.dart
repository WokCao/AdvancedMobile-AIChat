import 'package:flutter/material.dart';

class RemoveChat extends StatefulWidget {
  const RemoveChat({super.key});

  @override
  State<RemoveChat> createState() => _RemoveChatState();
}

class _RemoveChatState extends State<RemoveChat> {
  bool isDeleteHovered = false;
  bool isCancelHovered = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Title row with close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Remove Conversation",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Close icon button
              Tooltip(
                message: "Close",
                child: IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  padding: EdgeInsets.all(2),
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text("Are you sure you want to delete this conversation?"),
          const SizedBox(height: 24),
          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Cancel button
              MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) => (setState(() => isCancelHovered = true)),
                onExit: (_) => (setState(() => isCancelHovered = false)),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.purple.shade200),
                      gradient: LinearGradient(
                        colors: [
                          isCancelHovered
                              ? Colors.pink.shade50
                              : Colors.transparent,
                          isCancelHovered
                              ? Colors.purple.shade50
                              : Colors.transparent,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: isCancelHovered ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              // Save button
              MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) => (setState(() => isDeleteHovered = true)),
                onExit: (_) => (setState(() => isDeleteHovered = false)),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                      color: isDeleteHovered ? Colors.red.shade600 : Colors.red.shade400
                    ),
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
