import 'package:flutter/material.dart';

class EditChatTitle extends StatefulWidget {
  final String title;
  final String initialValue;
  final int maxLength;
  final Function(String) onSave;

  const EditChatTitle({
    super.key,
    required this.title,
    this.initialValue = '',
    this.maxLength = 80,
    required this.onSave,
  });

  @override
  State<EditChatTitle> createState() => _EditChatTitle();
}

class _EditChatTitle extends State<EditChatTitle> {
  late TextEditingController _textController;
  int _currentLength = 0;
  bool isSaveHovered = false;
  bool isCancelHovered = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialValue);
    _currentLength = widget.initialValue.length;

    _textController.addListener(() {
      setState(() {
        _currentLength = _textController.text.length;
      });
    });
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
                widget.title,
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

          // Input field with character count
          TextField(
            controller: _textController,
            maxLength: widget.maxLength,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.purpleAccent,
                  width: 1.0,
                ),
              ),
              counterText: '',
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Align(
                  widthFactor: 1.2,
                  heightFactor: 1.0,
                  child: Text(
                    '$_currentLength/${widget.maxLength}',
                    style: TextStyle(
                      color:
                          _currentLength >= widget.maxLength
                              ? Colors.red
                              : Colors.grey,
                    ),
                  ),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            maxLines: 1,
            autofocus: true,
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
                onEnter: (_) => (setState(() => isSaveHovered = true)),
                onExit: (_) => (setState(() => isSaveHovered = false)),
                child: GestureDetector(
                  onTap: () {
                    widget.onSave(_textController.text);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.purple.shade200),
                      gradient: LinearGradient(
                        colors: [
                          isSaveHovered
                              ? Colors.pink.shade400
                              : Colors.pink.shade300,
                          isSaveHovered
                              ? Colors.purple.shade400
                              : Colors.purple.shade300,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: const Text(
                      'Save',
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
