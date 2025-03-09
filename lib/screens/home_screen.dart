import 'package:flutter/material.dart';
import '../widgets/app_sidebar.dart';
import '../widgets/selector_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSidebarVisible = false;
  final TextEditingController _textController = TextEditingController();
  bool _isInputFocused = false;

  // AI Models data
  final List<Map<String, dynamic>> _modelData = [
    {
      'name': 'GPT-4o mini',
      'icon': Icons.auto_awesome,
      'description': "OpenAI's latest model, great for most everyday tasks",
      'tokenCount': 'Cost 1 Tokens',
      'iconColor': Colors.blue,
    },
    {
      'name': 'GPT-4o',
      'icon': Icons.auto_awesome_outlined,
      'iconColor': Colors.purple,
    },
    {
      'name': 'Gemini 1.5 Flash',
      'icon': Icons.flash_on,
      'iconColor': Colors.amber,
    },
    {
      'name': 'Gemini 1.5 Pro',
      'icon': Icons.workspace_premium,
      'iconColor': Colors.black,
    },
    {
      'name': 'Claude 3 Haiku',
      'icon': Icons.psychology,
      'iconColor': Colors.orange,
    },
    {
      'name': 'Claude 3 Sonnet',
      'icon': Icons.psychology_outlined,
      'iconColor': Colors.brown,
    },
    {
      'name': 'Deepseek Chat',
      'icon': Icons.chat_bubble_outline,
      'iconColor': Colors.blue,
    },
  ];

  late String _selectedModel;
  final GlobalKey _modelSelectorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _selectedModel = _modelData[0]['name'];
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

    final size = renderBox.size;
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
      offset: Offset(offset.dx + 16, offset.dy - 400), // Position above the button
    );
  }

  // Get the current model data
  Map<String, dynamic> get _currentModel {
    return _modelData.firstWhere(
          (model) => model['name'] == _selectedModel,
      orElse: () => _modelData[0],
    );
  }

  @override
  void dispose() {
    _textController.dispose();
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
              Container(
                padding: EdgeInsets.all(5.0),
                child: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: _toggleSidebar,
                  tooltip: 'Toggle sidebar',
                ),
              ),

              // Empty space for content
              const Expanded(
                child: Center(
                  child: Text(
                    'No messages yet',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              Row(
                children: [
                  // AI model selector
                  Container(
                    key: _modelSelectorKey,
                    margin: const EdgeInsets.only(left: 16.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: InkWell(
                      onTap: _showModelSelector,
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
                  // Create bot button
                  Container(
                    margin: const EdgeInsets.only(left: 16.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.purple.shade200, Colors.purple.shade300], // Gradient colors
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: InkWell(
                      /// Add onTap here
                      onTap: () {},
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

                  const Spacer(),

                  IconButton(
                    icon: const Icon(Icons.history),
                    iconSize: 32,
                    onPressed: () {},
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

              // Bottom input section
              MouseRegion(
                onEnter: (_) => setState(() => _isInputFocused = true),
                onExit: (_) => setState(() => _isInputFocused = false),
                child: Container(
                  margin: const EdgeInsets.all(16.0),
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
                                  hintText: 'Ask me anything, press \' for prompts...',
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
                                textCapitalization: TextCapitalization.sentences,
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
                                onPressed: () {},
                                tooltip: 'View prompts',
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.send),
                                iconSize: 20,
                                onPressed: () {
                                  if (_textController.text.trim().isNotEmpty) {
                                    // Handle send message
                                    _textController.clear();
                                  }
                                },
                                tooltip: 'Send message',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),

          // Floating Sidebar
          AppSidebar(
            isExpanded: true,
            isVisible: _isSidebarVisible,
            selectedIndex: 0,
            onItemSelected: (_) {},
            onToggleExpanded: () {},
            onClose: _closeSidebar,
          ),
        ],
      ),
    );
  }
}