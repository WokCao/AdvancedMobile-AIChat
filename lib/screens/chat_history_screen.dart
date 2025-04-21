import 'package:ai_chat/widgets/history/chat_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utils/get_api_utils.dart';
import '../utils/time_utils.dart';
import '../widgets/chat_message.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  List<Map<String, dynamic>> _chatItems = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchChatHistory();
  }

  Future<void> _fetchChatHistory() async {
    try {
      final apiService = getApiService(context);
      final conversations = await apiService.getConversations(
        modelId: 'gpt-4o-mini',
      );

      setState(() {
        _chatItems = conversations;
        _loading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Failed to load history: $e");
      }
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Chat History",
                    style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                  Tooltip(
                    message: "Close",
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.close,
                          color: Colors.grey,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: ListView.separated(
                        itemCount: _chatItems.length,
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.grey.shade300,
                          thickness: 1,
                          height: 8,
                          indent: 4,
                          endIndent: 4,
                        ),
                        itemBuilder: (context, index) {
                          final item = _chatItems[index];
                          return ChatItem(
                            content: item['title'] ?? 'Untitled',
                            time: formatRelativeTime(item['createdAt']),
                            onTap: () async {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => Center(child: CircularProgressIndicator(color: Colors.purple.shade200)),
                              );

                              final api = getApiService(context);

                              final conversationId = item['id'];
                              final messages = await api.getConversationHistory(conversationId: conversationId);

                              if (context.mounted) Navigator.of(context).pop();

                              Navigator.pop(context, {
                                'messages': messages,
                                'conversationId': conversationId,
                              });
                            },
                          );
                        },
                      ),
                    )
            ],
          ),
        )
      ),
    );
  }
}