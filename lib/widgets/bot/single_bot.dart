import 'package:ai_chat/models/bot_model.dart';
import 'package:ai_chat/providers/bot_provider.dart';
import 'package:ai_chat/widgets/bot/remove_bot.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/get_api_utils.dart';
import 'create_bot_dialog.dart';

class SingleBot extends StatefulWidget {
  final BotModel botModel;
  final VoidCallback? onBotUpdated;

  const SingleBot({
    super.key,
    required this.botModel,
    this.onBotUpdated,
  });

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
      child: InkWell(
        onTap: () {
          context.read<BotProvider>().setSelectedBotModel(botModel: widget.botModel);
          Navigator.pushNamed(context, '/playground');
        },
        child: Card(
          color: Colors.white,
          elevation: isHovered ? 8 : 4,
          shadowColor: Colors.black,
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
                      size: 48,
                      color: Colors.purple.shade200,
                    ),
                    title: Text(
                      widget.botModel.assistantName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      widget.botModel.description ?? '',
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Tooltip(
                          message: "Favorite",
                          child: Icon(Icons.star_border_outlined, color: Colors.purple.shade200,),
                        ),
                        SizedBox(width: 12),
                        Tooltip(
                          message: "Edit",
                          child: GestureDetector(
                            onTap: () async {
                              final result = await showDialog<bool>(
                                context: context,
                                builder: (context) => CreateBotDialog(
                                  isEditing: true,
                                  botId: widget.botModel.id,
                                  initialName: widget.botModel.assistantName,
                                  initialInstructions: widget.botModel.instructions,
                                  initialDescription: widget.botModel.description,
                                ),
                              );
                              if (result == true) {
                                widget.onBotUpdated?.call();
                              }
                            },
                            child: Icon(Icons.edit_outlined, color: Colors.purple.shade200),
                          ),
                        ),
                        SizedBox(width: 12),
                        Tooltip(
                          message: "Delete",
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return RemoveBot(
                                    id: widget.botModel.id,
                                    onBotRemoved: widget.onBotUpdated,
                                  );
                                }
                              );
                            },
                            child: Icon(Icons.delete_outline_outlined, color: Colors.purple.shade200,),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.access_time_outlined, color: Colors.grey,),
                        SizedBox(width: 4),
                        Text("01/01/2025", style: TextStyle(color: Colors.grey),),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
