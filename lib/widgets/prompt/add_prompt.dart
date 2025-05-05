import 'package:ai_chat/models/prompt_model.dart';
import 'package:flutter/material.dart';

import '../../utils/get_api_utils.dart';

class AddPrompt extends StatefulWidget {
  final PromptModel? prompt;
  final void Function(String, String, String)? updatePrivatePromptCallback;
  const AddPrompt({super.key, this.updatePrivatePromptCallback, this.prompt});

  @override
  State<AddPrompt> createState() => _AddPrompt();
}

class _AddPrompt extends State<AddPrompt> {
  bool isCreateHovered = false;
  bool isCancelHovered = false;
  int _currentLength = 0;
  late final TextEditingController _textController;
  late final TextEditingController _promptTextController;

  @override
  void initState() {
    _textController = TextEditingController(text: widget.prompt?.title);
    _promptTextController = TextEditingController(text: widget.prompt?.content);
    _textController.addListener(() {
      setState(() {
        _currentLength = _textController.text.length;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _promptTextController.dispose();
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
          // Title row with close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.prompt!.title.isEmpty ? "New Prompt" : "Update Prompt",
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
          const SizedBox(height: 20),
          Form(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Name",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      "*",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _textController,
                  maxLength: 80,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.purpleAccent,
                        width: 1.0,
                      ),
                    ),
                    hintText: "Name of the prompt",
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Align(
                        widthFactor: 1.2,
                        heightFactor: 1.0,
                        child: Text(
                          '$_currentLength/${80}',
                          style: TextStyle(
                            color:
                                _currentLength >= 80 ? Colors.red : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    counterText: '',
                  ),
                  maxLines: 1,
                  autofocus: true,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "Prompt",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      "*",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _promptTextController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.purpleAccent,
                        width: 1.0,
                      ),
                    ),
                    hintText:
                        "e.g: Write an article about [TOPIC], make sure to include these keywords: [KEYWORDS]",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.3,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  minLines: 3,
                  maxLines: 8,
                  autofocus: false,
                ),
              ],
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
              // Create button
              MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) => (setState(() => isCreateHovered = true)),
                onExit: (_) => (setState(() => isCreateHovered = false)),
                child: GestureDetector(
                  onTap: () async {
                    final title = _textController.text.trim();
                    final content = _promptTextController.text.trim();

                    if (title.isEmpty || content.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please fill out all required fields"),
                        ),
                      );
                      return;
                    }

                    if (title == widget.prompt?.title || content == widget.prompt?.content) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Title or Prompt is unchanged"),
                        ),
                      );
                      return;
                    }

                    final apiService = getApiService(context);
                    bool success = false;

                    if (widget.prompt?.title != "") {
                      success = await apiService.updatePrivatePrompt(
                        title: title,
                        content: content,
                        id: widget.prompt!.id,
                      );
                    } else {
                      success = await apiService.createPrivatePrompt(
                        title: title,
                        content: content,
                        description: "User-created prompt",
                      );
                    }

                    if (success) {
                      Navigator.of(context).pop(true);
                      if (widget.updatePrivatePromptCallback != null) {
                        widget.updatePrivatePromptCallback!(widget.prompt!.id, title, content);
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Prompt ${widget.prompt?.title != "" ? "updated" : "created"} successfully")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Failed to ${widget.prompt?.title != "" ? "update" : "create"} prompt")),
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.purple.shade200),
                      gradient: LinearGradient(
                        colors: [
                          isCreateHovered
                              ? Colors.pink.shade400
                              : Colors.pink.shade300,
                          isCreateHovered
                              ? Colors.purple.shade400
                              : Colors.purple.shade300,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Text(
                      widget.prompt?.title != '' ? 'Update' : 'Create',
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
