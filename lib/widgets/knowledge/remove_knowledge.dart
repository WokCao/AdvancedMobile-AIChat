import 'package:flutter/material.dart';

class RemoveKnowledge extends StatefulWidget {
  final void Function(String)? handleDeleteKnowledge;
  final String? id;
  const RemoveKnowledge({super.key, this.handleDeleteKnowledge, this.id});

  @override
  State<RemoveKnowledge> createState() => _RemoveKnowledgeState();
}

class _RemoveKnowledgeState extends State<RemoveKnowledge> {
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
                "Remove Knowledge",
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
          const Text("Are you sure you want to delete this knowledge?"),
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
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
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
              const SizedBox(width: 8),
              // Save button
              MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) => (setState(() => isDeleteHovered = true)),
                onExit: (_) => (setState(() => isDeleteHovered = false)),
                child: GestureDetector(
                  onTap: () {
                    if (widget.handleDeleteKnowledge != null && widget.id != null) {
                      widget.handleDeleteKnowledge!(widget.id!);
                    } else if (widget.handleDeleteKnowledge != null) {
                      widget.handleDeleteKnowledge!('_');
                    }
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 18),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.purple.shade200),
                        color: isDeleteHovered ? Colors.purple.shade600 : Colors.purple.shade400
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
