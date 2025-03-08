import 'package:flutter/material.dart';
import '../widgets/app_sidebar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSidebarVisible = false;
  final TextEditingController _textController = TextEditingController();
  bool _isInputFocused = false;

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