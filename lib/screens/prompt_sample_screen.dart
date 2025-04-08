import 'package:ai_chat/widgets/prompt/add_prompt.dart';
import 'package:ai_chat/widgets/prompt/prompt_item.dart';
import 'package:ai_chat/widgets/prompt/segmented_button.dart';
import 'package:flutter/material.dart';
import '../utils/get_api_utils.dart';
import '../widgets/prompt/personal_prompt_item.dart';

class PromptSampleScreen extends StatefulWidget {
  const PromptSampleScreen({super.key});

  @override
  State<PromptSampleScreen> createState() => _PromptSampleScreenState();
}

class _PromptSampleScreenState extends State<PromptSampleScreen> {
  bool isHovered = false;
  Prompt prompt = Prompt.public;

  final List<Map<String, dynamic>> _publicPrompts = [];
  bool _isLoading = true;

  final ScrollController _scrollController = ScrollController();

  int _offset = 0;
  bool _hasNext = true;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    _fetchPublicPrompts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 &&
          !_isFetchingMore &&
          _hasNext) {
        setState(() => _isFetchingMore = true);
        _fetchPublicPrompts();
      }
    });
  }

  Future<void> _fetchPublicPrompts() async {
    final apiService = getApiService(context);
    final data = await apiService.getPublicPrompts(offset: _offset);

    setState(() {
      _publicPrompts.addAll(List<Map<String, dynamic>>.from(data['items']));
      _hasNext = data['hasNext'] ?? false;
      _offset += 20;
      _isLoading = false;
      _isFetchingMore = false;
    });
  }

  void _promptCallback(Prompt selectedPrompt) {
    setState(() {
      prompt = selectedPrompt;
    });
  }

  void _showAddPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddPrompt();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Prompt Library",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Tooltip(
                        message: "Add Prompt",
                        child: GestureDetector(
                          onTap: _showAddPrompt,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            onEnter: (_) => setState(() => isHovered = true),
                            onExit: (_) => setState(() => isHovered = false),
                            child: Container(
                              padding: EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.pink.shade300,
                                    Colors.purple.shade300,
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Icon(
                                Icons.add,
                                color:
                                    isHovered ? Colors.white : Colors.white70,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
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
                            child: Icon(Icons.close, color: Colors.grey, size: 24),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              SegmentedButtonWidget(promptCallback: _promptCallback),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search_sharp),
                        hintText: "Search...",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.purpleAccent,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  if (prompt == Prompt.public)
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.star_border,
                          color: Colors.grey.shade500,
                          size: 25,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  children: [
                    ...(prompt == Prompt.public
                      ? (_isLoading
                        ? [Center(child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Center(child: CircularProgressIndicator()),
                          ))]
                          : _publicPrompts.map((p) {
                              return PromptItem(
                                name: p['title'] ?? 'Untitled',
                                description: p['description'] ?? '',
                              );
                            }).toList()
                      )
                      : List.generate(
                        2,
                        (index) => PersonalPromptItem(
                          name: "Testing",
                          prompt: "This is a sample prompt description.",
                        ),
                      )),
                    if (_isFetchingMore)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
