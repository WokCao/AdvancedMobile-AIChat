import 'package:ai_chat/models/bot_model.dart';
import 'package:ai_chat/models/knowledge_model.dart';
import 'package:ai_chat/providers/bot_provider.dart';
import 'package:ai_chat/providers/knowledge_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/auth_provider.dart';
import '../utils/get_api_utils.dart';
import '../widgets/bot/publish_bot_dialog.dart';
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
  bool _isUpdating = false;
  bool _fetchFirstTime = false;

  late BotModel _botModel;

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

  Future<void> updateInstructions() async {
    setState(() {
      _isUpdating = true;
    });

    final api = getKBApiService(context);
    final success = await api.updateBot(
      id: _botModel.id,
      assistantName: _botModel.assistantName,
      instructions: _personaController.text.trim(),
    );

    if (success) {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  Future<void> handleSendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    ChatMessage botMessage(String id, String message) {
      return ChatMessage(
        id: id,
        message: message,
        type: MessageType.ai,
        senderName: _botModel.assistantName,
        senderIcon: Icons.smart_toy_outlined,
        iconColor: Colors.blue,
      );
    }

    setState(() {
      // Add user message
      _messages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          message: text,
          type: MessageType.user,
        ),
      );

      // Add temporary loading message
      _messages.add(botMessage('loading', 'Typing...'));

      // Scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

      // Clear input
      _messageController.clear();
    });

    String reply = '';

    final api = getKBApiService(context);
    final token =
        Provider.of<AuthProvider>(context, listen: false).user?.accessToken;
    await api.askBotStream(
      assistantId: _botModel.id,
      message: text,
      authToken: token ?? '',
      onData: (data) {
        reply += data['content'];
      },
      onDone: () {
        setState(() {
          _messages.removeWhere((msg) => msg.id == 'loading');
          _messages.add(
            botMessage(DateTime.now().millisecondsSinceEpoch.toString(), reply),
          );
        });
      },
      onError: (e) {
        setState(() {
          _messages.removeWhere((msg) => msg.id == 'loading');
          _messages.add(
            botMessage(
              DateTime.now().millisecondsSinceEpoch.toString(),
              'Error: $e',
            ),
          );
        });
      },
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

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
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

    setState(() {
      if (botModel != null && !_fetchFirstTime) {
        _botModel = botModel;
        _personaController.text = botModel.instructions ?? '';
        _fetchFirstTime = true;
      }
    });

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
                  onPressed: () async {
                    // Handle read docs
                    final Uri url = Uri.parse('https://jarvis.cx/help/');

                    if (!await launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    )) {
                      throw Exception('Could not launch $url');
                    }
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
                    showDialog(
                      context: context,
                      builder: (_) => const PublishBotDialog(),
                    );
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
                      'Persona & Instructions',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _isUpdating
                        ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : IconButton(
                          onPressed: updateInstructions,
                          icon: Icon(
                            Icons.check_circle_outline,
                            size: 18,
                            color: Colors.purple,
                          ),
                          padding: EdgeInsets.all(0),
                        ),
                  ],
                ),
                const SizedBox(height: 8),
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
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 100),
            child: ListView.builder(
              shrinkWrap: true,
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

                                      context
                                          .read<BotProvider>()
                                          .removeAKnowledge(item);
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

          Container(
            margin: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity, // Make button full width
              child: OutlinedButton.icon(
                onPressed: () {
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
          ),
          const SizedBox(height: 4),

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
                        onPressed: _isMessageHasText ? handleSendMessage : null,
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
