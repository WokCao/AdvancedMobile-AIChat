import 'dart:async';

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

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Timer? _debounce;

  final List<String> _categories = [
    "All", "Business", "Career", "Chatbot", "Coding", "Education", "Fun", "Marketing", "Productivity", "SEO", "Writing", "Other",
  ];

  String _selectedCategory = "All";

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
    final data = await apiService.getPublicPrompts(offset: _offset, query: _searchQuery, category: _selectedCategory);

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
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
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
              // Search
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        if (_debounce?.isActive ?? false) _debounce!.cancel();
                        _debounce = Timer(Duration(milliseconds: 500), () {
                          setState(() {
                            _searchQuery = value.trim();
                            _offset = 0;
                            _hasNext = true;
                            _isLoading = true;
                            _publicPrompts.clear();
                          });
                          _fetchPublicPrompts(); // 🔁 refresh with query
                        });
                      },
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
              SizedBox(height: 14),
              // Categories
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _categories.map((category) {
                  final isSelected = category == _selectedCategory;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                        _offset = 0;
                        _hasNext = true;
                        _isLoading = true;
                        _publicPrompts.clear();
                      });
                      _fetchPublicPrompts(); // 🔁 refresh based on new category
                      _scrollController.jumpTo(0);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.purple.shade200 : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              // Prompts
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  children: [
                    ...(prompt == Prompt.public
                      ? (_isLoading
                        ? [Center(child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: CircularProgressIndicator(),
                          ))]
                          : (_publicPrompts.isEmpty
                              ? [Center(child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  child: Text("No prompts found"),
                                ))]
                              : _publicPrompts.map((p) {
                                  return PromptItem(
                                    name: p['title'] ?? 'Untitled',
                                    description: p['description'] ?? '',
                                  );
                                }).toList())
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
