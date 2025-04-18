import 'package:flutter/material.dart';
import '../models/prompt_model.dart';
import '../utils/get_api_utils.dart';
import '../widgets/app_sidebar.dart';
import '../widgets/bot/create_bot_dialog.dart';
import '../widgets/chat_message.dart';
import '../widgets/prompt/use_prompt.dart';
import '../widgets/selector_menu/selector_item.dart';
import '../widgets/selector_menu/selector_menu_helper.dart';
import '../widgets/welcome.dart';

class HomeScreen extends StatefulWidget {
  final bool? showUsePrompt;
  final PromptModel? promptModel;

  const HomeScreen({super.key, this.showUsePrompt, this.promptModel});

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
  late PromptModel? _selectedPrompt;

  // Selector items
  int _offset = 0;
  bool _hasMore = true;

  final List<ChatMessage> _messages = [];
  int _remainingTokens = -1;

  // AI Models data
  final List<Map<String, dynamic>> _modelData = [
    {
      'name': 'GPT-4o mini',
      'apiId': 'gpt-4o-mini',
      'icon': Icons.auto_awesome,
      'iconColor': Colors.blue,
      'description':
          "OpenAI's latest model, very fast and great for most everyday tasks.",
      'tokenCount': 'Cost 1 Token',
    },
    {
      'name': 'GPT-4o',
      'apiId': 'gpt-4o',
      'icon': Icons.auto_awesome_outlined,
      'iconColor': Colors.purple,
      'description':
          "Most capable model, best for complex tasks while maintaining quality.",
      'tokenCount': 'Cost 5 Tokens',
    },
    {
      'name': 'Gemini 1.5 Flash',
      'apiId': 'gemini-1.5-flash-latest',
      'icon': Icons.flash_on,
      'iconColor': Colors.amber,
      'description':
          "Google's latest model, optimized for narrower or high-frequency tasks where the speed of the model's response time matters the most.",
      'tokenCount': 'Cost 1 Token',
    },
    {
      'name': 'Gemini 1.5 Pro',
      'apiId': 'gemini-1.5-pro-latest',
      'icon': Icons.workspace_premium,
      'iconColor': Colors.black,
      'description':
          "Google's next-generation model, best for complex tasks requiring advanced reasoning.",
      'tokenCount': 'Cost 5 Tokens',
    },
    {
      'name': 'Claude 3 Haiku',
      'apiId': 'claude-3-haiku-20240307',
      'icon': Icons.psychology,
      'iconColor': Colors.orange,
      'description':
          "Anthropic's most compact model, designed for near-instant responsiveness and seamless AI experiences that mimic human interactions.",
      'tokenCount': 'Cost 1 Token',
    },
    {
      'name': 'Claude 3 Sonnet',
      'apiId': 'claude-3-sonnet-20240229',
      'icon': Icons.psychology_outlined,
      'iconColor': Colors.brown,
      'description':
          "Anthropic's most intelligent model to date between intelligence and speed, ideal for a wide range of tasks.",
      'tokenCount': 'Cost 3 Tokens',
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
    _selectedPrompt = null;

    if (widget.showUsePrompt != null) {
      _isUsePromptVisible = widget.showUsePrompt!;
    }

    // Scroll to bottom after initial render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
      _loadTokenCount();
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
    final items =
        _modelData.map((model) {
          return SelectorItem<String>(
            title: model['name'],
            leading: Icon(model['icon'], size: 20, color: model['iconColor']),
            subtitle: model['description'],
            trailing: model['tokenCount'],
            value: model['name'],
          );
        }).toList();

    // Get the position of the button
    final RenderBox? renderBox =
        _modelSelectorKey.currentContext?.findRenderObject() as RenderBox?;
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
      offset: Offset(
        offset.dx + 16,
        offset.dy - 320,
      ), // Position above the button
    );
  }

  Future<List<PromptModel>> _fetchPublicPrompts() async {
    if (!_hasMore) return [];

    final apiService = getApiService(context);
    final data = await apiService.getPublicPrompts(offset: _offset, limit: 10);

    final List<PromptModel> fetched = (data['items'] as List)
        .map((item) => PromptModel.fromJson(item))
        .toList();

    setState(() {
      _offset += fetched.length;
      _hasMore = fetched.length == 10;
    });

    return fetched;
  }


  Future<void> _showPromptSelector() async {
    final scrollController = ScrollController();

    final initialPrompts = await _fetchPublicPrompts();
    List<SelectorItem<PromptModel>> promptItems = initialPrompts.map((p) => SelectorItem<PromptModel>(title: p.title, value: p)).toList();

    // Get the position of the input
    final RenderBox? renderBox =
        _promptSelectorKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final offset = renderBox.localToGlobal(Offset.zero);

    // Show the menu above the input
    SelectorMenuHelper.showMenu<PromptModel>(
      context: context,
      items: promptItems,
      selectedValue: _selectedPrompt,
      onItemSelected: (value) {
        setState(() {
          _selectedPrompt = value;
          _isUsePromptVisible = true;
        });
        // Handle item selected
      },
      title: 'Suggested Prompts',
      offset: Offset(
        offset.dx + 16,
        offset.dy - 300,
      ), // Position above the input
      scrollController: scrollController,
      onLoadMore: () async {
        final newPrompts = await _fetchPublicPrompts();
        return newPrompts.map((p) => SelectorItem<PromptModel>(title: p.title, value: p)).toList();
      },
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
    } else {
      setState(() {
        _isInputHasText = false;
      });
    }
  }

  Future<void> _handleSendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      // Add user message
      _messages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          message: text,
          type: MessageType.user,
        ),
      );

      // Clear input
      _textController.clear();
    });

    // Scroll to bottom
    _scrollToBottom();

    // Bot message template
    ChatMessage botMessage(String id, String message) {
      return ChatMessage(
        id: id,
        message: message,
        type: MessageType.ai,
        senderName: _currentModel['name'],
        senderIcon: _currentModel['icon'],
        iconColor: _currentModel['iconColor'],
      );
    }

    // Show temporary loading message
    const loadingMessageId = 'loading';
    setState(() {
      _messages.add(botMessage(loadingMessageId, 'Typing...'));
    });

    try {
      final modelId = _currentModel['apiId']; // ensure this is mapped correctly to API model
      
      final apiService = getApiService(context);
      final result = await apiService.sendMessage(
        content: text,
        modelId: modelId,
      );
      
      final reply = result['message'];
      final remaining = result['remainingUsage'];
      
      setState(() {
        // Remove loading message
        _messages.removeWhere((msg) => msg.id == loadingMessageId);
        _messages.add(botMessage(DateTime.now().millisecondsSinceEpoch.toString(), reply));
      });
      
      _remainingTokens = remaining ?? _remainingTokens;
    } on Exception catch (e) {
      setState(() {
        _messages.removeWhere((msg) => msg.id == loadingMessageId);
        _messages.add(botMessage(DateTime.now().millisecondsSinceEpoch.toString(), '⚠️ Failed to get response: $e'));
      });
    }

    _scrollToBottom();
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

  Future<void> _loadTokenCount() async {
    final apiService = getApiService(context);
    final tokens = await apiService.getAvailableTokens();

    if (tokens != null) {
      setState(() {
        _remainingTokens = tokens;
      });
    }
  }

  void addToChatInput(String content) {
    _textController.text = content;
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
                child:
                  _messages.isEmpty
                    ? Welcome()
                    : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        // Adds a gap below each item
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 10,
                          ),
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
                        color:
                            _isAISelectorFocused
                                ? Colors.purple.shade100.withValues(alpha: 0.5)
                                : Colors.purple.shade50,
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
                            const Icon(Icons.expand_more, size: 20),
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
                            builder: (context) => CreateBotDialog(),
                          );
                        },
                        borderRadius: BorderRadius.circular(24),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.smart_toy_outlined, color: Colors.white),
                            const SizedBox(width: 4),
                            Icon(Icons.add, color: Colors.white),
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
                        bottomRight: Radius.circular(30.0),
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      color: Colors.white,
                      onPressed: () {},
                      tooltip: 'New chat',
                    ),
                  ),
                ],
              ),

              // Chat input
              MouseRegion(
                key: _promptSelectorKey,
                onEnter: (_) => setState(() => _isInputFocused = true),
                onExit: (_) => setState(() => _isInputFocused = false),
                child: Container(
                  margin: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 12.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color:
                        _isInputFocused
                            ? Colors.transparent
                            : Colors.purple.shade50,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                    border: Border.all(
                      color:
                          _isInputFocused ? Colors.purple : Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
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
                                  hintText:
                                  'Ask me anything, press \'/\' for prompts...',
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
                                maxLines: 5,
                                minLines: 2,
                                textCapitalization:
                                TextCapitalization.sentences,
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
                                onPressed:
                                    _isInputHasText ? _handleSendMessage : null,
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
                      padding: const EdgeInsets.only(
                        top: 4,
                        bottom: 4,
                        left: 8,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: _remainingTokens == -1
                            ? [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              ]
                            : [
                                Icon(Icons.diamond, color: Colors.purple, size: 16),
                                const SizedBox(width: 2),
                                Text(
                                  "$_remainingTokens",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
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
                            style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.rocket_launch,
                            color: Colors.purple,
                            size: 18,
                          ),
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
          if (_isUsePromptVisible && (widget.promptModel != null || _selectedPrompt != null)) UsePrompt(onClose: _hideUsePrompt, promptModel: widget.promptModel ?? _selectedPrompt!, addToChatInput: addToChatInput, quickPrompt: widget.promptModel != null ? false : true,),
        ],
      ),
    );
  }
}
