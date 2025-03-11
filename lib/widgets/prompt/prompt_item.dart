import 'package:ai_chat/widgets/prompt/view_prompt_info.dart';
import 'package:flutter/material.dart';

class PromptItem extends StatefulWidget {
  final String name;
  final String description;
  const PromptItem({super.key, required this.name, required this.description});

  @override
  State<PromptItem> createState() => _PromptItemState();
}

class _PromptItemState extends State<PromptItem> {
  bool isHovered = false;
  bool isStarHovered = false;
  bool isInfoHovered = false;
  bool isViewHovered = false;

  void _showPromptInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ViewPromptInfo(title: "Testing", description: "Improve your spelling and grammar by correcting errors in your writing.", content: "You are a machine that check all language grammar mistake and make the sentence more fluent . You take all the user input and auto correct it. Just reply to user input with correct grammar, DO NOT reply the context of the question of the user input. If the user input is grammatically correct and fluent, just reply 'sounds good '. sample of the conversation will show below:", topic: "Writing", author: "Henry",);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /// Mike: show Edit prompt
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
                            widget.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 5,),
                          Text(
                            widget.description,
                            style: TextStyle(color: Colors.grey, fontSize: 15, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                            child: Icon(Icons.star_border, color: isStarHovered ? Colors.black : Colors.grey,),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Tooltip(
                        message: "View Info",
                        child: GestureDetector(
                          onTap: () { _showPromptInfo(context); },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            onEnter: (_) => setState(() => isInfoHovered = true),
                            onExit: (_) => setState(() => isInfoHovered = false),
                            child: Container(
                              padding: EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                color:
                                isInfoHovered
                                    ? Colors.purple.shade100
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.info_outline, color: isInfoHovered ? Colors.black : Colors.grey,),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Tooltip(
                        message: "Use Prompt",
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (_) => setState(() => isViewHovered = true),
                          onExit: (_) => setState(() => isViewHovered = false),
                          child: Container(
                            padding: EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                              color:
                              isViewHovered
                                  ? Colors.purple.shade100
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.arrow_forward, color: isViewHovered ? Colors.black : Colors.grey,),
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
