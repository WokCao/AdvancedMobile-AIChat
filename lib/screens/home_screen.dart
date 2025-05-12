import 'dart:io';

import 'package:ai_chat/providers/subscription_provider.dart';
import 'package:ai_chat/widgets/ads/banner_ad_widget.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/prompt_model.dart';
import '../providers/prompt_provider.dart';
import '../services/openai_service.dart';
import '../utils/get_api_utils.dart';
import '../widgets/app_sidebar.dart';
import '../widgets/bot/create_bot_dialog.dart';
import '../widgets/chat_message.dart';
import '../widgets/file_preview.dart';
import '../widgets/file_preview_list.dart';
import '../widgets/prompt/use_prompt.dart';
import '../widgets/selector_menu/selector_item.dart';
import '../widgets/selector_menu/selector_menu_helper.dart';
import '../widgets/welcome.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSidebarVisible = false;
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _textController = TextEditingController();
  bool _isInputFocused = false;
  bool _isInputHasText = false;

  bool _isAISelectorFocused = false;
  bool _isBotCreateFocused = false;

  bool _isUsePromptVisible = false;
  String? _lastConversationId;
  bool _loadingConversation = false;

  bool _fetchingBots = false;

  final List<PlatformFile> _selectedFiles = [];
  bool _uploadingFile = false;

  // Selector items
  int _offset = 0;
  bool _hasMore = true;

  List<ChatMessage> _messages = [];
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
  List<Map<String, dynamic>> _botData = [];

  late String _selectedModel;
  final GlobalKey _modelSelectorKey = GlobalKey();
  final GlobalKey _promptSelectorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _selectedModel = _modelData[0]['name'];
    _textController.addListener(_handleTextChange);

    final selectedPromptModel = context.read<PromptProvider>().promptModel;
    if (selectedPromptModel != null) {
      _isUsePromptVisible = true;
    }

    // Scroll to bottom after initial render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
      _loadTokenCount();
      _loadLastConversation();
      _fetchBots();
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

  Future<void> _showModelSelector() async {
    final modelItems =
        _modelData.map((model) {
          return SelectorItem<String>(
            title: model['name'],
            leading: Icon(model['icon'], size: 20, color: model['iconColor']),
            subtitle: model['description'],
            trailing: model['tokenCount'],
            value: model['name'],
          );
        }).toList();

    final botItems =
        _botData.map((bot) {
          return SelectorItem<String>(
            title: bot['name'],
            leading: Icon(bot['icon'], size: 20, color: bot['iconColor']),
            subtitle: bot['description'],
            value: 'bot:${bot['apiId']}',
          );
        }).toList();

    final items = [
      SelectorItem<String>(title: 'title:Base AI Models'),
      ...modelItems,
      if (botItems.isNotEmpty) ...[
        SelectorItem<String>(title: 'title:Your Bots'),
        ...botItems,
      ],
    ];

    final renderBox =
        _modelSelectorKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final offset = renderBox.localToGlobal(Offset.zero);

    SelectorMenuHelper.showMenu<String>(
      context: context,
      items: items,
      selectedValue: _selectedModel,
      onItemSelected: (value) {
        setState(() {
          _selectedModel = value;
          if (value.startsWith('bot:')) {
            _messages = [];
            _lastConversationId = null;
          }
        });
      },
      offset: Offset(offset.dx + 16, offset.dy - 320 - (botItems.length * 28)),
    );
  }

  Future<List<PromptModel>> _fetchPublicPrompts() async {
    if (!_hasMore) return [];

    final apiService = getApiService(context);
    final data = await apiService.getPublicPrompts(offset: _offset, limit: 10);

    final List<PromptModel> fetched =
        (data['items'] as List)
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
    List<SelectorItem<PromptModel>> promptItems =
        initialPrompts
            .map((p) => SelectorItem<PromptModel>(title: p.title, value: p))
            .toList();

    // Get the position of the input
    final RenderBox? renderBox =
        _promptSelectorKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final offset = renderBox.localToGlobal(Offset.zero);

    // Show the menu above the input
    if (mounted) {
      SelectorMenuHelper.showMenu<PromptModel>(
        context: context,
        items: promptItems,
        selectedValue: null,
        onItemSelected: (value) {
          context.read<PromptProvider>().setSelectedPromptModel(
            promptModel: value,
          );
          setState(() {
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
          return newPrompts
              .map((p) => SelectorItem<PromptModel>(title: p.title, value: p))
              .toList();
        },
      );
    }
  }

  Future<void> _fetchBots() async {
    setState(() => _fetchingBots = true);

    final api = getKBApiService(context);
    final bots = await api.getBots();

    setState(() {
      _botData =
          bots
              .map(
                (bot) => {
                  'apiId': bot.id,
                  'name': bot.assistantName,
                  'description': bot.description ?? '',
                  'type': 'bot',
                  'icon': Icons.smart_toy_outlined,
                  'iconColor': Colors.blue,
                },
              )
              .toList();
      _fetchingBots = false;
    });
  }

  // Get the current model data
  Map<String, dynamic> get _currentModel {
    if (_selectedModel.startsWith("bot:")) {
      final id = _selectedModel.split(":")[1];
      return _botData.firstWhere(
        (b) => b['apiId'] == id,
        orElse: () => _botData[0],
      );
    } else {
      return _modelData.firstWhere(
        (m) => m['name'] == _selectedModel,
        orElse: () => _modelData[0],
      );
    }
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

  Future<void> _handleSendMessage({String textFromPrompt = ''}) async {
    final text =
        textFromPrompt.isNotEmpty
            ? textFromPrompt
            : _textController.text.trim();
    if (text.isEmpty) return;

    final isUsingBot = _selectedModel.startsWith("bot:");
    final assistantId = isUsingBot ? _selectedModel.split(":")[1] : null;

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

    const loadingMessageId = 'loading';

    try {
      Map<String, dynamic> result;

      final modelId = _currentModel['apiId'];
      final modelName = _currentModel['name'];

      List<String> uploadedUrls = [];

      for (final file in _selectedFiles) {
        final url = await _uploadFile(file);
        if (url != null) uploadedUrls.add(url);
      }

      setState(() {
        _selectedFiles.clear();

        // Add user message
        _messages.add(
          ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            message: text,
            type: MessageType.user,
            files: uploadedUrls,
          ),
        );

        // Add temporary loading message
        _messages.add(botMessage(loadingMessageId, 'Typing...'));

        // Scroll to bottom
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

        // Clear input
        _textController.clear();
      });

      final api = getApiService(context);
      result = await api.sendMessage(
        content: text,
        modelId: isUsingBot ? assistantId : modelId,
        modelType: isUsingBot ? 'kb' : 'dify',
        modelName: modelName,
        conversationId: _lastConversationId,
        files: uploadedUrls,
      );

      final reply = result['message'];
      final remaining = result['remainingUsage'];

      setState(() {
        // Remove loading message
        _messages.removeWhere((msg) => msg.id == loadingMessageId);
        _messages.add(
          botMessage(DateTime.now().millisecondsSinceEpoch.toString(), reply),
        );
        _lastConversationId = result['conversationId'];
      });

      _remainingTokens = remaining ?? _remainingTokens;
    } on Exception catch (e) {
      setState(() {
        _messages.removeWhere((msg) => msg.id == loadingMessageId);
        _messages.add(
          botMessage(
            DateTime.now().millisecondsSinceEpoch.toString(),
            '⚠️ Failed to get response: $e',
          ),
        );
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
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
          files: oldMessage.files,
        );
      }
    });
  }

  void _hideUsePrompt() {
    context.read<PromptProvider>().setSelectedPromptModel(promptModel: null);
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
    _hideUsePrompt();
  }

  Future<void> _loadLastConversation() async {
    setState(() => _loadingConversation = true);

    final api = getApiService(context);

    // Get most recent conversation ID
    final conversations = await api.getConversations(
      modelId: _currentModel['apiId'],
      limit: 1,
    );
    if (conversations.isEmpty)
      return setState(() => _loadingConversation = false);

    final conversationId = conversations[0]['id'];

    // Get messages for that conversation
    final messages = await api.getConversationHistory(
      conversationId: conversationId,
      modelId: _currentModel['apiId'],
    );

    // Parse into chat model
    final parsed = parseConversationHistory(messages);

    setState(() {
      _messages = parsed;
      _lastConversationId = conversationId;
      _loadingConversation = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  List<ChatMessage> parseConversationHistory(
    List<Map<String, dynamic>> messages,
  ) {
    return messages.expand((msg) {
      final createdAt = msg['createdAt'].toString();
      return [
        ChatMessage(
          id: '$createdAt-user',
          message: msg['query'],
          type: MessageType.user,
        ),
        ChatMessage(
          id: '$createdAt-bot',
          message: msg['answer'],
          type: MessageType.ai,
          senderName: _currentModel['name'],
          senderIcon: _currentModel['icon'],
          iconColor: _currentModel['iconColor'],
        ),
      ];
    }).toList();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'txt',
        'md',
        'pdf',
        'html',
        'xlsx',
        'xls',
        'docx',
        'csv',
        'msg',
        'pptx',
        'ppt',
        'xml',
        'epub',
        'jpg',
        'jpeg',
        'png',
        'gif',
        'webp',
        'svg',
      ],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFiles.addAll(result.files);
      });
    }
  }

  Future<String?> _uploadFile(PlatformFile file) async {
    setState(() => _uploadingFile = true);

    const cloudName = 'dtworggdn';
    const uploadPreset = 'ai-chat-files';

    final uploadUrl = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/auto/upload',
    );

    final fileBytes = file.bytes!;
    final fileName = file.name;

    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(fileBytes, filename: fileName),
      'upload_preset': uploadPreset,
    });

    try {
      final response = await Dio().postUri(uploadUrl, data: formData);
      return response.data['secure_url'];
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Upload failed: ${e.toString()}')));
    } finally {
      setState(() => _uploadingFile = false);
    }

    return null;
  }

  Future<void> _takePhoto() async {
    try {
      PlatformFile? platformFile;

      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        // 📱 Mobile (Android/iOS)
        final ImagePicker picker = ImagePicker();
        final XFile? photo = await picker.pickImage(source: ImageSource.camera);

        if (photo != null) {
          final bytes = await photo.readAsBytes();
          platformFile = PlatformFile(
            name: photo.name,
            size: bytes.length,
            bytes: bytes,
            path: photo.path,
          );
        }
      } else {
        // 🌐 Web or Desktop fallback: open image file
        final result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          withData: true,
        );

        if (result != null && result.files.isNotEmpty) {
          platformFile = result.files.first;
        }
      }

      if (platformFile != null) {
        setState(() {
          _selectedFiles.add(platformFile!);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  // redirect to jarvis pricing page
  final Uri _url = Uri.parse('https://dev.jarvis.cx/pricing');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedPromptModel = context.watch<PromptProvider>().promptModel;

    return Scaffold(
      body: Stack(
        children: [
          // Main content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 28),

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
                _loadingConversation
                    ? Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
                    : _messages.isEmpty
                    ? Welcome()
                    : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    // Adds a gap below each item
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
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
                    onEnter:
                        (_) => setState(() => _isAISelectorFocused = true),
                    onExit:
                        (_) => setState(() => _isAISelectorFocused = false),
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
                            ? Colors.purple.shade100.withValues(
                          alpha: 0.5,
                        )
                            : Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: InkWell(
                        onTap: _showModelSelector,
                        hoverColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                        child: SizedBox(
                          width: 120,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _currentModel['icon'],
                                size: 20,
                                color: _currentModel['iconColor'],
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  _currentModel['name'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              _fetchingBots
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                  : const Icon(Icons.expand_more, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Create bot button
                  MouseRegion(
                    onEnter:
                        (_) => setState(() => _isBotCreateFocused = true),
                    onExit:
                        (_) => setState(() => _isBotCreateFocused = false),
                    child: Container(
                      margin: const EdgeInsets.only(left: 2.0),
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
                        onTap: () async {
                          final result = await showDialog<bool>(
                            context: context,
                            builder: (context) => CreateBotDialog(),
                          );
                          if (result == true) {
                            _fetchBots();
                          }
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
                    onPressed: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        "/history",
                        arguments: {
                          'lastConversationId': _lastConversationId,
                        },
                      );
                      if (result != null && result is Map) {
                        final messages = result['messages'];
                        final conversationId =
                        result['conversationId'] as String;

                        final parsed = parseConversationHistory(messages);

                        setState(() {
                          _messages = parsed;
                          _lastConversationId = conversationId;
                        });

                        WidgetsBinding.instance.addPostFrameCallback(
                              (_) => _scrollToBottom(),
                        );
                      }
                    },
                    tooltip: 'Chat history',
                  ),
                  const SizedBox(width: 2),
                  SizedBox(
                    height: 32,
                    width: 48,
                    child: Container(
                      margin: const EdgeInsets.only(right: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade300,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0),
                        ),
                      ),
                      // child: IconButton(
                      //   icon: const Icon(Icons.add),
                      //   color: Colors.white,
                      //   padding: EdgeInsets.zero,
                      //   constraints: const BoxConstraints(),
                      //   onPressed: () {},
                      //   tooltip: 'New chat',
                      // ),
                      child: IconButton(
                        icon: const Icon(Icons.add),
                        padding: EdgeInsets.zero,
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            _messages = [];
                            _lastConversationId = null;
                          });
                        },
                        tooltip: 'New chat',
                      ),
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
                  padding: const EdgeInsets.only(
                    left: 4.0,
                    right: 4.0,
                    top: 12.0,
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
                      _isInputFocused
                          ? Colors.purple
                          : Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: SafeArea(
                    top: false,
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

                        if (_selectedFiles.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 14.0),
                            child: FilePreviewList(
                              files: _selectedFiles,
                              onRemove: (index) {
                                setState(
                                      () => _selectedFiles.removeAt(index),
                                );
                              },
                            ),
                          ),

                        // Buttons row
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.attach_file),
                                iconSize: 20,
                                onPressed: _pickFile,
                                tooltip: 'Attach file',
                              ),
                              IconButton(
                                icon: const Icon(Icons.camera_alt),
                                iconSize: 20,
                                onPressed: _takePhoto,
                                tooltip: 'Take photo',
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
                              _uploadingFile
                                  ? Padding(
                                padding: const EdgeInsets.only(
                                  right: 16.0,
                                ),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.purple,
                                  ),
                                ),
                              )
                                  : IconButton(
                                icon: const Icon(Icons.send),
                                iconSize: 20,
                                color: Colors.purple,
                                onPressed:
                                _isInputHasText
                                    ? _handleSendMessage
                                    : null,
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
                padding: EdgeInsets.only(
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0,
                ),
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
                        children:
                        _remainingTokens == -1
                            ? [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ]
                            : [
                          Icon(
                            Icons.diamond,
                            color: Colors.purple,
                            size: 16,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            "$_remainingTokens",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (!context
                        .read<SubscriptionProvider>()
                        .subscription
                        .unlimited)
                      TextButton(
                        onPressed: _launchUrl,
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
              BannerAdWidget(),
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
          if (_isUsePromptVisible && selectedPromptModel != null)
            UsePrompt(
              onClose: _hideUsePrompt,
              promptModel: selectedPromptModel,
              addToChatInput: addToChatInput,
              handleSendMessage: _handleSendMessage,
            ),
        ],
      ),
    );
  }
}
