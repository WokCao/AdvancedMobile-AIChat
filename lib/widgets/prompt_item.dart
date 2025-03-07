import 'package:flutter/material.dart';

class PromptItem extends StatefulWidget {
  final String title;
  final String description;
  const PromptItem({super.key, required this.title, required this.description});

  @override
  State<PromptItem> createState() => _PromptItemState();
}

class _PromptItemState extends State<PromptItem> {
  bool isHovered = false;
  bool isStarHovered = false;
  bool isInfoHovered = false;
  bool isViewHovered = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: Container(
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 25.0, 10.0),
            decoration: BoxDecoration(
              color: isHovered ? Colors.purple[50] : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        widget.description,
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) => setState(() => isStarHovered = true),
                      onExit: (_) => setState(() => isStarHovered = false),
                      child: Container(
                        padding: EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          color:
                              isStarHovered
                                  ? Colors.purple.shade200
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.star_border, color: isStarHovered ? Colors.black : Colors.grey,),
                      ),
                    ),
                    SizedBox(width: 8),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) => setState(() => isInfoHovered = true),
                      onExit: (_) => setState(() => isInfoHovered = false),
                      child: Container(
                        padding: EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          color:
                              isInfoHovered
                                  ? Colors.purple.shade200
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.info_outline, color: isInfoHovered ? Colors.black : Colors.grey,),
                      ),
                    ),
                    SizedBox(width: 8),
                    MouseRegion(
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
                  ],
                ),
              ],
            ),
          ),
        ),
        const Divider(thickness: 1.5,),
      ],
    );
  }
}
