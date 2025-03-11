import 'package:flutter/material.dart';

class SingleBot extends StatefulWidget {
  final String name;
  final String description;
  const SingleBot({super.key, required this.name, required this.description});

  @override
  State<SingleBot> createState() => _SingleBotState();
}

class _SingleBotState extends State<SingleBot> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Card(
        color: Colors.white,
        elevation: isHovered ? 8 : 4,
        shadowColor: Colors.pink.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListTile(
                  leading: Icon(
                    Icons.smart_toy_outlined,
                    size: 52,
                    color: Colors.blue.shade300,
                  ),
                  title: Text(
                    widget.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    widget.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Tooltip(
                        message: "Mark as Fav",
                        child: Icon(Icons.star_border_outlined),
                      ),
                      SizedBox(width: 12),
                      Tooltip(
                        message: "Delete",
                        child: Icon(Icons.delete_outline_outlined),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.access_time_outlined),
                      SizedBox(width: 4),
                      Text("01/01/2025"),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
