import 'package:flutter/material.dart';

class ViewPromptInfo extends StatefulWidget {
  final String title;
  final String description;
  final String content;
  final String topic;
  final String author;

  const ViewPromptInfo({
    super.key,
    required this.title,
    required this.description,
    required this.content,
    required this.topic,
    required this.author,
  });

  @override
  State<ViewPromptInfo> createState() => _ViewPromptInfoState();
}

class _ViewPromptInfoState extends State<ViewPromptInfo> {
  bool isUseHovered = false;
  bool isCancelHovered = false;
  bool isStarHovered = false;
  bool isCopyHovered = false;
  late final TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController(text: widget.content);
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Close icon button
              Row(
                children: [
                  Tooltip(
                    message: "Favorite",
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) => setState(() => isStarHovered = true),
                      onExit: (_) => setState(() => isStarHovered = false),
                      child: Container(
                        padding: EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          color:
                              isStarHovered
                                  ? Colors.purple.shade100
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.star_border,
                          color: isStarHovered ? Colors.black : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
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
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                widget.topic,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 8,),
              Icon(Icons.circle, size: 8,),
              SizedBox(width: 8,),
              Text(
                widget.author,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              )
            ],
          ),
          SizedBox(height: 4),
          Text(widget.description, style: TextStyle(color: Colors.grey.shade600),),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Prompt",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(width: 4),
              Tooltip(
                message: "Copy",
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => setState(() => isCopyHovered = true),
                  onExit: (_) => setState(() => isCopyHovered = false),
                  child: Container(
                    padding: EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      color:
                      isCopyHovered
                          ? Colors.purple.shade100
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.copy,
                      color: isCopyHovered ? Colors.black : Colors.grey,
                      size: 16,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: _textController,
              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, height: 1.4),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                border: InputBorder.none
              ),
              maxLines: 8,
              readOnly: true,
            ),
          ),
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
                    margin: EdgeInsets.only(right: 8),
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
              const SizedBox(width: 4),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) => (setState(() => isUseHovered = true)),
                onExit: (_) => (setState(() => isUseHovered = false)),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    /// Mike: Show Edit prompt
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.purple.shade200),
                      gradient: LinearGradient(
                        colors: [
                          isUseHovered
                              ? Colors.pink.shade400
                              : Colors.pink.shade300,
                          isUseHovered
                              ? Colors.purple.shade400
                              : Colors.purple.shade300,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: const Text(
                      'Use Prompt',
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
