import 'dart:async';
import 'dart:js_interop';

import 'package:ai_chat/models/prompt_model.dart';
import 'package:ai_chat/widgets/prompt/add_prompt.dart';
import 'package:ai_chat/widgets/prompt/prompt_item.dart';
import 'package:ai_chat/widgets/prompt/segmented_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/get_api_utils.dart';
import '../widgets/prompt/personal_prompt_item.dart';

class PromptSampleScreen extends StatefulWidget {
  const PromptSampleScreen({super.key});

  @override
  State<PromptSampleScreen> createState() => _PromptSampleScreenState();
}

class _PromptSampleScreenState extends State<PromptSampleScreen> {
  bool isHovered = false;
  bool _showFavoritesOnly = false;
  Prompt prompt = Prompt.public;

  final List<PromptModel> _publicPrompts = [];
  final List<PromptModel> _privatePrompts = [];
  bool _isLoading = true;

  final ScrollController _scrollController = ScrollController();
  int _offset = 0;
  bool _hasNext = true;
  bool _isFetchingMore = false;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Timer? _debounce;

  final List<String> _categories = [
    "All",
    "Business",
    "Career",
    "Chatbot",
    "Coding",
    "Education",
    "Fun",
    "Marketing",
    "Productivity",
    "SEO",
    "Writing",
    "Other",
  ];

  String _selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    _fetchPublicPrompts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !_isFetchingMore &&
          _hasNext) {
        setState(() => _isFetchingMore = true);
        if (prompt == Prompt.public) {
          _fetchPublicPrompts();
        } else {
          _fetchPrivatePrompts();
        }
      }
    });
  }

  Future<void> _fetchPublicPrompts() async {
    final apiService = getApiService(context);
    final data = await apiService.getPublicPrompts(
      offset: _offset,
      query: _searchQuery,
      category: _selectedCategory,
      isFavorite: _showFavoritesOnly,
    );

    setState(() {
      _publicPrompts.addAll(
        (data['items'] as List)
            .map((item) => PromptModel.fromJson(item))
            .toList(),
      );
      _hasNext = data['hasNext'] ?? false;
      _offset += 20;
      _isLoading = false;
      _isFetchingMore = false;
    });
  }

  Future<void> _fetchPrivatePrompts() async {
    final apiService = getApiService(context);
    final data = await apiService.getPrivatePrompts(
      offset: _offset,
      query: _searchQuery,
      limit: 8
    );

    setState(() {
      _privatePrompts.addAll(
        (data['items'] as List)
            .map((item) => PromptModel.fromJson(item))
            .toList(),
      );
      _hasNext = data['hasNext'] ?? false;
      _offset += 8;
      _isLoading = false;
      _isFetchingMore = false;
    });
  }

  void _promptCallback(Prompt selectedPrompt) {
    setState(() {
      prompt = selectedPrompt;

      setState(() {
        _offset = 0;
        _hasNext = true;
        _isLoading = true;
        _privatePrompts.clear();
      });

      if (selectedPrompt == Prompt.public) {
        setState(() {
          _publicPrompts.clear();
        });
        _fetchPublicPrompts();
      } else {
        setState(() {
          _privatePrompts.clear();
        });
        _fetchPrivatePrompts();
      }

      _scrollController.jumpTo(0);
    });
  }

  Future<void> _showAddPrompt() async {
    final shouldShowPersonal = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddPrompt();
      },
    );

    if (shouldShowPersonal == true) {
      setState(() {
        prompt = Prompt.personal; // ✅ switch tab
        _offset = 0;
        _hasNext = true;
        _isLoading = true;
        _privatePrompts.clear(); // optional: reset list
      });
      _fetchPrivatePrompts(); // ✅ load personal prompts again
    }
  }

  void removePrivatePromptCallback(String id) {
    setState(() {
      _privatePrompts.removeWhere((prompt) => prompt.id == id);
    });
  }

  void updatePrivatePromptCallback(String id, String title, String content) {
    setState(() {
      final index = _privatePrompts.indexWhere((prompt) => prompt.id == id);
      if (index != -1) {
        _privatePrompts[index] = _privatePrompts[index].copyWith(
          title: title,
          content: content,
        );
      }
    });
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
              // Title
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
                ],
              ),
              SizedBox(height: 20),
              // Prompt Buttons
              SegmentedButtonWidget(
                prompt: prompt,
                promptCallback: _promptCallback,
              ),
              SizedBox(height: 20),
              // Search
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        final isPublic = prompt == Prompt.public;

                        if (_debounce?.isActive ?? false) _debounce!.cancel();
                        _debounce = Timer(Duration(milliseconds: 500), () {
                          setState(() {
                            _searchQuery = value.trim();
                            _offset = 0;
                            _hasNext = true;
                            _isLoading = true;
                            isPublic ? _publicPrompts.clear() : _privatePrompts.clear();
                          });
                          isPublic ? _fetchPublicPrompts() : _fetchPrivatePrompts(); // 🔁 refresh with query
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
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        tooltip: 'Show Favorites',
                        icon: Icon(
                          _showFavoritesOnly ? Icons.star : Icons.star_border,
                          color:
                              _showFavoritesOnly ? Colors.amber : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _showFavoritesOnly = !_showFavoritesOnly;
                            _offset = 0;
                            _hasNext = true;
                            _isLoading = true;
                            _publicPrompts.clear();
                          });
                          _fetchPublicPrompts();
                        },
                      ),
                    ),
                ],
              ),
              SizedBox(height: 14),
              // Categories
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children:
                    prompt == Prompt.public
                        ? _categories.map((category) {
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
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? Colors.purple.shade200
                                        : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                category,
                                style: TextStyle(
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList()
                        : [],
              ),
              SizedBox(height: 10),
              // Prompts
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  children: [
                    ...(() {
                      if (_isLoading) {
                        return const [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ];
                      }

                      final isPublic = prompt == Prompt.public;
                      final prompts =
                          isPublic ? _publicPrompts : _privatePrompts;

                      if (prompts.isEmpty) {
                        return [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'binoculars.png',
                                    width: 128,
                                    height: 128,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "No prompts found",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 128),
                                  Text.rich(
                                    TextSpan(
                                      text: "Find more prompts in ",
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 16,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "Public prompts",
                                          style: TextStyle(
                                            color: Colors.purple,
                                          ),
                                          recognizer:
                                              TapGestureRecognizer()
                                                ..onTap = () {
                                                  setState(() {
                                                    prompt = Prompt.public;
                                                    _selectedCategory = "All";
                                                    _offset = 0;
                                                    _hasNext = true;
                                                    _isLoading = true;
                                                    _publicPrompts.clear();
                                                  });
                                                  _fetchPublicPrompts();
                                                  _scrollController.jumpTo(0);
                                                },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      text: "or ",
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 16,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "Create your own prompt",
                                          style: TextStyle(
                                            color: Colors.purple,
                                          ),
                                          recognizer:
                                              TapGestureRecognizer()
                                                ..onTap = () {
                                                  _showAddPrompt();
                                                },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ];
                      }

                      return prompts.map((PromptModel p) {
                        return isPublic
                            ? PromptItem(promptModel: p)
                            : PersonalPromptItem(
                              promptModel: p,
                              removePrivatePromptCallback:
                                  removePrivatePromptCallback,
                              updatePrivatePromptCallback:
                                  updatePrivatePromptCallback,
                            );
                      }).toList();
                    })(),

                    if (_isFetchingMore)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
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
