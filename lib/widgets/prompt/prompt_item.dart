import 'package:ai_chat/models/prompt_model.dart';
import 'package:ai_chat/providers/prompt_provider.dart';
import 'package:ai_chat/screens/home_screen.dart';
import 'package:ai_chat/widgets/prompt/view_prompt_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/get_api_utils.dart';

class PromptItem extends StatefulWidget {
  final PromptModel promptModel;

  const PromptItem({
    super.key,
    required this.promptModel,
  });

  @override
  State<PromptItem> createState() => _PromptItemState();
}

class _PromptItemState extends State<PromptItem> {
  bool isHovered = false;
  bool isStarHovered = false;
  bool isInfoHovered = false;
  bool isViewHovered = false;
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.promptModel.isFavorite;
  }

  void _showPromptInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ViewPromptInfo(promptModel: widget.promptModel,);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<PromptProvider>().setSelectedPromptModel(promptModel: widget.promptModel);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.only(right: 16.0),
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
                                overflow: TextOverflow.ellipsis
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              widget.promptModel.description ?? 'No description',
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
                            child: InkWell(
                              onTap: () async {
                                final apiService = getApiService(context);
                                final success = await apiService.togglePromptFavorite(
                                  widget.promptModel.id,
                                  isCurrentlyFavorited: _isFavorite,
                                );

                                if (success) {
                                  setState(() {
                                    _isFavorite = !_isFavorite;
                                  });
                                }
                              },
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
                                  _isFavorite ? Icons.star : Icons.star_border,
                                  color: _isFavorite ? Colors.amber : (isStarHovered ? Colors.black : Colors.grey),
                                ),
                              ),
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
      ),
    );
  }
}
