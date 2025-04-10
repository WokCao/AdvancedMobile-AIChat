import 'package:ai_chat/models/prompt_model.dart';
import 'package:ai_chat/widgets/prompt/remove_prompt.dart';
import 'package:flutter/material.dart';

import '../../screens/home_screen.dart';
import 'add_prompt.dart';

class PersonalPromptItem extends StatefulWidget {
  final PromptModel promptModel;
  final void Function(String) removePrivatePromptCallback;
  final void Function(String, String, String) updatePrivatePromptCallback;


  const PersonalPromptItem({
    super.key,
    required this.promptModel,
    required this.removePrivatePromptCallback,
    required this.updatePrivatePromptCallback,
  });

  @override
  State<PersonalPromptItem> createState() => _PersonalPromptItemState();
}

class _PersonalPromptItemState extends State<PersonalPromptItem> {
  bool isHovered = false;
  bool isEditHovered = false;
  bool isDeleteHovered = false;
  bool isViewHovered = false;

  void _showRemovePrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RemovePrompt(id: widget.promptModel.id, removePrivatePromptCallback: widget.removePrivatePromptCallback,);
      },
    );
  }

  void _showAddPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddPrompt(title: widget.promptModel.title, prompt: widget.promptModel.content, id: widget.promptModel.id, updatePrivatePromptCallback: widget.updatePrivatePromptCallback,);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(showUsePrompt: true, promptModel: widget.promptModel,),
          ),
        );
      },
      child: Column(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => isHovered = true),
            onExit: (_) => setState(() => isHovered = false),
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: isHovered ? Colors.purple[50] : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(right: 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.promptModel.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Tooltip(
                        message: "Edit",
                        child: GestureDetector(
                          onTap: () {
                            _showAddPrompt();
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            onEnter: (_) => setState(() => isEditHovered = true),
                            onExit: (_) => setState(() => isEditHovered = false),
                            child: Container(
                              padding: EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                color:
                                isEditHovered
                                    ? Colors.purple.shade100
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.edit_outlined,
                                color: isEditHovered ? Colors.black : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Tooltip(
                        message: "Delete",
                        child: GestureDetector(
                          onTap: () {
                            _showRemovePrompt();
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            onEnter:
                                (_) => setState(() => isDeleteHovered = true),
                            onExit:
                                (_) => setState(() => isDeleteHovered = false),
                            child: Container(
                              padding: EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                color:
                                    isDeleteHovered
                                        ? Colors.purple.shade100
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.delete_forever,
                                color:
                                    isDeleteHovered
                                        ? Colors.black
                                        : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Tooltip(
                        message: "Use Prompt",
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(showUsePrompt: true, promptModel: widget.promptModel,),
                              ),
                            );
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            onEnter:
                                (_) => setState(() => isViewHovered = true),
                            onExit:
                                (_) => setState(() => isViewHovered = false),
                            child: Container(
                              padding: EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                color:
                                    isViewHovered
                                        ? Colors.purple.shade100
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.arrow_forward,
                                color:
                                    isViewHovered ? Colors.black : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Divider(thickness: 1.5),
        ],
      ),
    );
  }
}
