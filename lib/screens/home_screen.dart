import 'package:flutter/material.dart';
import '../widgets/app_sidebar.dart';
import '../widgets/bot/create_bot_dialog.dart';
import '../widgets/chat_message.dart';
import '../widgets/prompt/use_prompt.dart';
import '../widgets/welcome.dart';
import '../widgets/selector_menu.dart';

class HomeScreen extends StatefulWidget {
  final bool? showUsePrompt;

  const HomeScreen({
    super.key,
    this.showUsePrompt,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSidebarVisible = false;
  final TextEditingController _textController = TextEditingController();
  bool _isInputFocused = false;
  bool _isInputHasText = false;
  bool _isAISelectorFocused = false;
  bool _isBotCreateFocused = false;
  final ScrollController _scrollController = ScrollController();
  bool _isUsePromptVisible = false;

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

  // AI Models data
  final List<Map<String, dynamic>> _modelData = [
    {
      'name': 'GPT-4o mini',
      'icon': Icons.auto_awesome,
      'iconColor': Colors.blue,
      'description': "OpenAI's latest model, very fast and great for most everyday tasks.",
      'tokenCount': 'Cost 1 Token',
    },
    {
      'name': 'GPT-4o',
      'icon': Icons.auto_awesome_outlined,
      'iconColor': Colors.purple,
      'description': "Most capable model, best for complex tasks while maintaining quality.",
      'tokenCount': 'Cost 5 Tokens',
    },
    {
      'name': 'Gemini 1.5 Flash',
      'icon': Icons.flash_on,
      'iconColor': Colors.amber,
      'description': "Google's latest model, optimized for narrower or high-frequency tasks where the speed of the model's response time matters the most.",
      'tokenCount': 'Cost 1 Token',
    },
    {
      'name': 'Gemini 1.5 Pro',
      'icon': Icons.workspace_premium,
      'iconColor': Colors.black,
      'description': "Google's next-generation model, best for complex tasks requiring advanced reasoning.",
      'tokenCount': 'Cost 5 Tokens',
    },
    {
      'name': 'Claude 3 Haiku',
      'icon': Icons.psychology,
      'iconColor': Colors.orange,
      'description': "Anthropic's most compact model, designed for near-instant responsiveness and seamless AI experiences that mimic human interactions.",
      'tokenCount': 'Cost 1 Token',
    },
    {
      'name': 'Claude 3 Sonnet',
      'icon': Icons.psychology_outlined,
      'iconColor': Colors.brown,
      'description': "Anthropic's most intelligent model to date between intelligence and speed, ideal for a wide range of tasks.",
      'tokenCount': 'Cost 3 Tokens',
    },
    {
      'name': 'Deepseek Chat',
      'icon': Icons.chat_bubble_outline,
      'iconColor': Colors.blue,
      'description': "Deepseek's model, address tasks requiring logical inference, mathematical problem-solving, and real-time decision-making.",
      'tokenCount': 'Cost 1 Token',
    },
  ];

  late String _selectedModel;
  final GlobalKey _modelSelectorKey = GlobalKey();
  final GlobalKey _promptSelectorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _selectedModel = _modelData[0]['name'];
    _textController.addListener(_handleTextChange);

    if (widget.showUsePrompt != null) {
      _isUsePromptVisible = widget.showUsePrompt!;
    }

    // Scroll to bottom after initial render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
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

  void _toggleSidebar() {
    setState(() {
      _isSidebarVisible = !_isSidebarVisible;
    });
  }

  void _closeSidebar() {
    setState(() {
      _isSidebarVisible = false;
    });
  }

  void _showModelSelector() {
    // Convert model data to selector items
    final items = _modelData.map((model) {
      return SelectorItem<String>(
        title: model['name'],
        leading: Icon(
          model['icon'],
          size: 20,
          color: model['iconColor'],
        ),
        subtitle: model['description'],
        trailing: model['tokenCount'],
        value: model['name'],
      );
    }).toList();

    // Get the position of the button
    final RenderBox? renderBox = _modelSelectorKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final offset = renderBox.localToGlobal(Offset.zero);

    // Show the menu above the button
    SelectorMenuHelper.showMenu<String>(
      context: context,
      items: items,
      selectedValue: _selectedModel,
      onItemSelected: (value) {
        setState(() {
          _selectedModel = value;
        });
      },
      title: 'Base AI Models',
      offset: Offset(offset.dx + 16, offset.dy - 370), // Position above the button
    );
  }

  void _showPromptSelector() {
    // Selector items
    final items = [
      SelectorItem<String>(title: 'Grammar corrector'),
      SelectorItem<String>(title: 'Learn Code FAST!'),
      SelectorItem<String>(title: 'Story generator'),
      SelectorItem<String>(title: 'Essay improver'),
      SelectorItem<String>(title: 'Pro tips generator'),
      SelectorItem<String>(title: 'Resume Editing'),
    ];

    // Get the position of the input
    final RenderBox? renderBox = _promptSelectorKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final offset = renderBox.localToGlobal(Offset.zero);

    // Show the menu above the input
    SelectorMenuHelper.showMenu<String>(
      context: context,
      items: items,
      selectedValue: '',
      onItemSelected: (value) {
        // Handle item selected
      },
      title: 'Suggested Prompts',
      offset: Offset(offset.dx + 16, offset.dy - 300), // Position above the input
    );
  }

  // Get the current model data
  Map<String, dynamic> get _currentModel {
    return _modelData.firstWhere(
          (model) => model['name'] == _selectedModel,
      orElse: () => _modelData[0],
    );
  }

  void _handleTextChange() {
    final text = _textController.text;
    if (text.startsWith('/')) {
      _showPromptSelector();
    }
    if (text.isNotEmpty) {
      setState(() {
        _isInputHasText = true;
      });
    }
    else {
      setState(() {
        _isInputHasText = false;
      });
    }
  }

  void _handleSendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      // Add user message
      _messages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: text,
        type: MessageType.user,
      ));

      // Clear input
      _textController.clear();
    });

    // Scroll to bottom
    _scrollToBottom();

    // Simulate AI response after a delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add(ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          message: 'I received your message: "$text"',
          type: MessageType.ai,
          senderName: _currentModel['name'],
        ));
      });

      // Scroll to bottom again
      _scrollToBottom();
    });
  }

  void _handleEditMessage(String id, String newMessage) {
    setState(() {
      final index = _messages.indexWhere((message) => message.id == id);
      if (index != -1) {
        // Create a new message with the updated text
        final oldMessage = _messages[index];
        _messages[index] = ChatMessage(
          id: oldMessage.id,
          message: newMessage,
          type: oldMessage.type,
          senderName: oldMessage.senderName,
          senderIcon: oldMessage.senderIcon,
          iconColor: oldMessage.iconColor,
        );
      }
    });
  }

  void _hideUsePrompt() {
    setState(() {
      _isUsePromptVisible = false;
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sidebar button
              Container(
                padding: EdgeInsets.all(5.0),
                child: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: _toggleSidebar,
                  tooltip: 'Toggle sidebar',
                ),
              ),

              // Chat messages
              Expanded(
                child: _messages.isEmpty
                  ? Welcome()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16), // Adds a gap below each item
                          child: ChatMessageWidget(
                            message: message,
                            onEditMessage: _handleEditMessage,
                          ),
                        );
                      },
                  ),
              ),

              // Above input
              Row(
                children: [
                  // AI model selector
                  MouseRegion(
                    onEnter: (_) => setState(() => _isAISelectorFocused = true),
                    onExit: (_) => setState(() => _isAISelectorFocused = false),
                    child: Container(
                      key: _modelSelectorKey,
                      margin: const EdgeInsets.only(left: 16.0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _isAISelectorFocused ? Colors.purple.shade100.withValues(alpha: 0.5) : Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: InkWell(
                        onTap: _showModelSelector,
                        hoverColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _currentModel['icon'],
                              size: 20,
                              color: _currentModel['iconColor'],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _currentModel['name'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.expand_more,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Create bot button
                  MouseRegion(
                    onEnter: (_) => setState(() => _isBotCreateFocused = true),
                    onExit: (_) => setState(() => _isBotCreateFocused = false),
                    child: Container(
                      margin: const EdgeInsets.only(left: 16.0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _isBotCreateFocused
                                ? Colors.pink.shade400
                                : Colors.pink.shade300,
                            _isBotCreateFocused
                                ? Colors.purple.shade400
                                : Colors.purple.shade300,
                          ], // Gradient colors
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => CreateBotDialog(
                              onSubmit: (name, instructions) {
                                // Handle bot creation
                              },
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(24),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                                Icons.smart_toy_outlined,
                                color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Icon(
                                Icons.add,
                                color: Colors.white
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  IconButton(
                    icon: const Icon(Icons.history),
                    iconSize: 32,
                    onPressed: () {
                      Navigator.pushNamed(context, "/history");
                    },
                    tooltip: 'Chat history',
                  ),
                  const SizedBox(width: 8),
                  Container(
                    margin: const EdgeInsets.only(right: 16.0),
                    padding: const EdgeInsets.all(0.0),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade300,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0)
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      color: Colors.white,
                      onPressed: () {},
                      tooltip: 'New chat',
                    )
                  ),
                ],
              ),

              // Chat input
              MouseRegion(
                key: _promptSelectorKey,
                onEnter: (_) => setState(() => _isInputFocused = true),
                onExit: (_) => setState(() => _isInputFocused = false),
                child: Container(
                  margin: const EdgeInsets.only(top: 8.0, bottom: 12.0, left: 16.0, right: 16.0),
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    color: _isInputFocused ? Colors.transparent : Colors.purple.shade50,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                    border: Border.all(
                      color: _isInputFocused ? Colors.purple : Colors.transparent
                    ),
                    borderRadius: BorderRadius.circular(8.0)
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        // Input row
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _textController,
                                decoration: InputDecoration(
                                  hintText: 'Ask me anything, press \'/\' for prompts...',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                ),
                                maxLines: null,
                                minLines: 2,
                                textCapitalization: TextCapitalization.sentences,
                                onSubmitted: (_) => _handleSendMessage(),
                              ),
                            ),
                          ],
                        ),

                        // Buttons row
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.attach_file),
                                iconSize: 20,
                                onPressed: () {},
                                tooltip: 'Attach file',
                              ),
                              IconButton(
                                icon: const Icon(Icons.auto_awesome),
                                iconSize: 20,
                                onPressed: () {
                                  Navigator.pushNamed(context, "/prompts");
                                },
                                tooltip: 'View prompts',
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.send),
                                iconSize: 20,
                                color: Colors.purple,
                                onPressed: _isInputHasText ? _handleSendMessage : null,
                                tooltip: 'Send message',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Below input
              Container(
                padding: EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 10),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.diamond, color: Colors.purple, size: 16),
                          const SizedBox(width: 2),
                          const Text(
                            "50",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        // Handle upgrade
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.purple,
                      ),
                      child: Row(
                        children: [
                          const Text(
                            "Upgrade",
                            style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.rocket_launch, color: Colors.purple, size: 18),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Floating sidebar
          AppSidebar(
            isExpanded: true,
            isVisible: _isSidebarVisible,
            selectedIndex: 0,
            onItemSelected: (_) {},
            onToggleExpanded: () {},
            onClose: _closeSidebar,
          ),

          // Use Prompt panel
          if (_isUsePromptVisible) UsePrompt(onClose: _hideUsePrompt),
        ],
      ),
    );
  }
}