import 'package:ai_chat/models/bot_model.dart';
import 'package:ai_chat/models/knowledge_model.dart';
import 'package:ai_chat/providers/bot_provider.dart';
import 'package:ai_chat/providers/knowledge_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/get_api_utils.dart';
import '../widgets/chat_message.dart';
import '../widgets/knowledge/remove_knowledge.dart';

class BotPlaygroundScreen extends StatefulWidget {
  const BotPlaygroundScreen({super.key});

  @override
  State<BotPlaygroundScreen> createState() => _BotPlaygroundScreenState();
}

class _BotPlaygroundScreenState extends State<BotPlaygroundScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isMessageHasText = false;
  final TextEditingController _personaController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _deleteKnowledgeLoading = false;

  // Mock messages
  // final List<ChatMessage> _messages = [
  //   ChatMessage(
  //     id: '1',
  //     message: 'Hello! How can I help you today?',
  //     type: MessageType.ai,
  //     senderName: 'GPT-4o mini',
  //     senderIcon: Icons.auto_awesome,
  //   ),
  //   ChatMessage(
  //     id: '2',
  //     message: 'I need help with a Flutter project. I\'m trying to create a chat interface.',
  //     type: MessageType.user,
  //   ),
  //   ChatMessage(
  //     id: '3',
  //     message: 'I\'d be happy to help with your Flutter chat interface! What specific aspects are you working on? Are you looking for help with the UI design, state management, or integrating with a backend service?',
  //     type: MessageType.ai,
  //     senderName: 'GPT-4o mini',
  //     senderIcon: Icons.auto_awesome,
  //   ),
  //   ChatMessage(
  //     id: '4',
  //     message: 'Mainly the UI design. I want to create message bubbles that look good for both the user and AI responses.',
  //     type: MessageType.user,
  //   ),
  //   ChatMessage(
  //     id: '5',
  //     message: 'For a chat UI in Flutter, you\'ll want to create a message bubble widget that can be styled differently based on whether it\'s a user or AI message. Here are some key components to consider:\n\n1. Different background colors for user vs AI messages\n2. Different alignment (user messages on right, AI on left)\n3. Avatars for each participant\n4. Timestamps\n5. Support for different content types (text, images, etc.)',
  //     type: MessageType.ai,
  //     senderName: 'GPT-4o mini',
  //     senderIcon: Icons.auto_awesome,
  //   ),
  //   ChatMessage(
  //     id: '6',
  //     message: 'That\'s helpful! Do you have any example code I could use as a starting point?',
  //     type: MessageType.user,
  //   ),
  //   ChatMessage(
  //     id: '7',
  //     message: 'Here\'s a simple example of a chat message widget in Flutter:\n\n```dart\nclass ChatBubble extends StatelessWidget {\n  final bool isUser;\n  final String message;\n  \n  const ChatBubble({\n    required this.isUser,\n    required this.message,\n  });\n  \n  @override\n  Widget build(BuildContext context) {\n    return Align(\n      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,\n      child: Container(\n        margin: EdgeInsets.symmetric(vertical: 8),\n        padding: EdgeInsets.all(12),\n        decoration: BoxDecoration(\n          color: isUser ? Colors.blue : Colors.grey[200],\n          borderRadius: BorderRadius.circular(12),\n        ),\n        child: Text(\n          message,\n          style: TextStyle(\n            color: isUser ? Colors.white : Colors.black,\n          ),\n        ),\n      ),\n    );\n  }\n}```\n\nYou can expand on this basic example to add avatars, timestamps, and other features.',
  //     type: MessageType.ai,
  //     senderName: 'GPT-4o mini',
  //     senderIcon: Icons.auto_awesome,
  //   ),
  //   ChatMessage(
  //     id: '8',
  //     message: 'Perfect! I\'ll use this as a starting point and customize it for my needs.',
  //     type: MessageType.user,
  //   ),
  //   ChatMessage(
  //     id: '9',
  //     message: 'Glad I could help! If you need any further assistance with your Flutter chat UI, feel free to ask. Good luck with your project!',
  //     type: MessageType.ai,
  //     senderName: 'GPT-4o mini',
  //     senderIcon: Icons.auto_awesome,
  //   ),
  //   ChatMessage(
  //     id: '10',
  //     message: 'One more question - what\'s the best way to handle scrolling in the chat list?',
  //     type: MessageType.user,
  //   ),
  //   ChatMessage(
  //     id: '11',
  //     message: 'For handling scrolling in a chat list, you\'ll want to use a ListView.builder with a ScrollController. Here are some best practices:\n\n1. Auto-scroll to the bottom when new messages arrive\n2. Allow the user to scroll up to view history\n3. Show a "scroll to bottom" button when the user has scrolled up and new messages arrive\n\nHere\'s how you can implement auto-scrolling to the bottom:\n\n```dart\n// In your state class\nfinal ScrollController _scrollController = ScrollController();\n\n// After adding a new message\nvoid _scrollToBottom() {\n  WidgetsBinding.instance.addPostFrameCallback((_) {\n    if (_scrollController.hasClients) {\n      _scrollController.animateTo(\n        _scrollController.position.maxScrollExtent,\n        duration: Duration(milliseconds: 300),\n        curve: Curves.easeOut,\n      );\n    }\n  });\n}\n```\n\nCall `_scrollToBottom()` whenever a new message is added to the chat.',
  //     type: MessageType.ai,
  //     senderName: 'GPT-4o mini',
  //     senderIcon: Icons.auto_awesome,
  //   ),
  // ];
  final List<ChatMessage> _messages = [];

  Future<void> getImportedKnowledge() async {
    final api = getKBApiService(context);

    final assistantId = context.read<BotProvider>().botModel?.id;
    if (assistantId == null) return;
    final response = await api.getImportedKnowledge(assistantId: assistantId);

    if (!mounted) return;

    context.read<BotProvider>().setImportedKnowledge(
      importedKnowledge:
          (response['data'] as List)
              .map((item) => KnowledgeModel.fromJson(item))
              .toList(),
    );
  }

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_handleTextChange);
    getImportedKnowledge();
  }

  void _handleTextChange() {
    final text = _messageController.text;
    if (text.isNotEmpty) {
      setState(() {
        _isMessageHasText = true;
      });
    } else {
      setState(() {
        _isMessageHasText = false;
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BotModel? botModel = context.watch<BotProvider>().botModel;
    final List<KnowledgeModel> importedKnowledge =
        context.watch<BotProvider>().importedKnowledge;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          const SizedBox(height: 36),

          // Top Header
          Container(
            padding: const EdgeInsets.only(
              top: 12.0,
              bottom: 16.0,
              right: 12.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                // WordBot Logo and Title
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        context.read<BotProvider>().clearAll();
                        Navigator.of(context).pop();
                      },
                      padding: EdgeInsets.all(4.0),
                      constraints: BoxConstraints(),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                    Icon(
                      Icons.smart_toy_outlined,
                      size: 32,
                      color: Colors.purple.shade200,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          botModel?.assistantName ?? 'Unidentified bot',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade50,
                            border: Border.all(color: Colors.purple.shade200),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_2_outlined,
                                size: 14,
                                color: Colors.purple.shade700,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Personal',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.purple.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                // Action Buttons
                TextButton.icon(
                  onPressed: () {
                    // Handle read docs
                  },
                  icon: const Icon(Icons.description_outlined),
                  label: const Text('Docs', style: TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {
                    // Handle publish bot
                  },
                  icon: const Icon(Icons.upload, size: 16, color: Colors.white),
                  label: const Text('Publish', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade400,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ],
            ),
          ),

          // Develop
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Develop',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Persona & Prompt',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.check_circle_outline,
                      size: 18,
                      color: Colors.purple,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _personaController,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText:
                        'Design the bot\'s persona, features and workflow using natural language.',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                  ),
                  style: TextStyle(fontSize: 12),
                  maxLines: null,
                  minLines: 1,
                ),
              ],
            ),
          ),

          // Knowledge
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Knowledge',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: ListView.builder(
              padding: const EdgeInsets.only(
                top: 16.0,
                left: 16.0,
                bottom: 16.0,
              ),
              itemCount: importedKnowledge.length,
              itemBuilder: (context, index) {
                final item = importedKnowledge[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: LinearGradient(
                            colors: [
                              Colors.yellow.shade300,
                              Colors.orange.shade300,
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                        ),
                        child: const Icon(
                          Icons.data_object_outlined,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.knowledgeName,
                          style: const TextStyle(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        onPressed: () {
                          context
                              .read<KnowledgeProvider>()
                              .setSelectedKnowledgeRow(item);
                          Navigator.pushNamed(context, '/units');
                        },
                        icon: const Icon(
                          Icons.remove_red_eye_outlined,
                          size: 18,
                        ),
                        padding: const EdgeInsets.all(4.0),
                        constraints: const BoxConstraints(),
                        tooltip: 'View',
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder:
                                (_) => RemoveKnowledge(
                                  handleDeleteKnowledge: (String _) async {
                                    if (botModel != null) {
                                      setState(() {
                                        _deleteKnowledgeLoading = true;
                                      });
                                      await getKBApiService(
                                        context,
                                      ).removeKnowledgeFromAssistant(
                                        assistantId: botModel.id,
                                        knowledgeId: item.id,
                                      );

                                      context.read<BotProvider>().removeAKnowledge(item);
                                      setState(() {
                                        _deleteKnowledgeLoading = false;
                                      });
                                    }
                                  },
                                ),
                          );
                        },
                        icon:
                            _deleteKnowledgeLoading
                                ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.grey,
                                    ),
                                  ),
                                )
                                : const Icon(Icons.delete_outline, size: 18),
                        padding: const EdgeInsets.all(4.0),
                        constraints: const BoxConstraints(),
                        tooltip: 'Remove',
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          SizedBox(
            width: double.infinity, // Make button full width
            child: OutlinedButton.icon(
              onPressed: () {
                /// Handle adding knowledge source
                Navigator.pushNamed(context, '/knowledge');
              },
              icon: Icon(Icons.add, color: Colors.purple.shade700),
              label: const Text('Add knowledge source'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.purple.shade700,
                side: BorderSide(color: Colors.purple.shade200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                alignment: Alignment.center,
              ),
            ),
          ),

          // Chat Area
          Expanded(
            child: Column(
              children: [
                // Preview Header
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade300),
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Preview',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Chat Content
                Expanded(
                  child:
                      _messages.isEmpty
                          ? Center(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Icon(
                                      Icons.smart_toy_outlined,
                                      size: 36,
                                      color: Colors.purple.shade300,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    botModel?.assistantName ??
                                        'Unidentified bot',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Start a conversation with the assistant',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    'by typing a message in the input box below.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.only(top: 16, bottom: 16),
                            itemCount: _messages.length,
                            itemBuilder: (context, index) {
                              final message = _messages[index];
                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 16,
                                ), // Adds a gap below each item
                                child: ChatMessageWidget(message: message),
                              );
                            },
                          ),
                ),
              ],
            ),
          ),

          // Message Input
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.purple.shade300,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        onPressed: () {
                          // Handle new thread
                        },
                        padding: EdgeInsets.all(8.0),
                        constraints: BoxConstraints(),
                        icon: Icon(
                          Icons.message,
                          size: 16,
                          color: Colors.white,
                        ),
                        tooltip: 'New thread',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(color: Colors.purple),
                          ),
                        ),
                        maxLines: null,
                        minLines: 1,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color:
                            _isMessageHasText
                                ? Colors.purple.shade300
                                : Colors.grey,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        onPressed:
                            _isMessageHasText
                                ? () {
                                  // Handle send message
                                }
                                : null,
                        padding: EdgeInsets.all(8.0),
                        constraints: BoxConstraints(),
                        icon: Icon(Icons.send, size: 16, color: Colors.white),
                        tooltip: 'Send message',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
