import 'package:ai_chat/utils/get_api_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/app_sidebar.dart';
import '../widgets/selector_menu/selector_item.dart';
import '../widgets/selector_menu/selector_menu_helper.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  bool _isSidebarVisible = false;

  final _mainIdeaController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _senderController = TextEditingController();
  final _receiverController = TextEditingController();

  String _length = 'long';
  String _formality = 'neutral';
  String _tone = 'friendly';
  String _language = '';
  String? _selectedModel;
  String? _generatedResponse;

  bool _isAISelectorFocused = false;
  final GlobalKey _modelSelectorKey = GlobalKey();

  bool _isGenerateFocused = false;
  bool _isSuggestFocused = false;
  bool _loading = false;

  bool _loadingIdeas = false;
  List<String> _suggestedIdeas = [];

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

  Future<void> _generateEmail() async {
    if (_mainIdeaController.text.trim().isEmpty || _emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in the Main Idea and Original Email Content first.')),
      );
      return;
    }

    setState(() => _loading = true);

    final api = getApiService(context);

    try {
      final response = await api.generateEmailResponse(
        modelId: _currentModel['apiId'],
        mainIdea: _mainIdeaController.text.trim(),
        action: 'Reply to this email',
        emailContent: _emailController.text.trim(),
        subject: _subjectController.text.trim(),
        sender: _senderController.text.trim(),
        receiver: _receiverController.text.trim(),
        length: _length,
        formality: _formality,
        tone: _tone,
        language: _language,
      );
      setState(() {
        _generatedResponse = response;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate email: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _fetchMainIdeas() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in the Original Email Content first.')),
      );
      return;
    }

    setState(() => _loadingIdeas = true);

    final api = getApiService(context);

    try {
      final ideas = await api.suggestReplyIdeas(
        modelId: _currentModel['apiId'],
        emailContent: _emailController.text.trim(),
        subject: _subjectController.text.trim(),
        sender: _senderController.text.trim(),
        receiver: _receiverController.text.trim(),
        language: _language,
      );

      if (ideas.isNotEmpty) {
        setState(() {
          _suggestedIdeas = ideas;
        });

        _showIdeaPicker();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No suggestions found.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error suggesting ideas: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _loadingIdeas = false);
      }
    }
  }

  void _showIdeaPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: _suggestedIdeas.length,
          itemBuilder: (context, index) {
            final idea = _suggestedIdeas[index];
            return ListTile(
              title: Text(idea),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _mainIdeaController.text = idea;
                });
              },
            );
          },
        );
      },
    );
  }

  Future<void> _showModelSelector() async {
    final modelItems = _modelData.map((model) {
      return SelectorItem<String>(
        title: model['name'],
        leading: Icon(model['icon'], size: 20, color: model['iconColor']),
        subtitle: model['description'],
        trailing: model['tokenCount'],
        value: model['name'],
      );
    }).toList();

    final items = [
      SelectorItem<String>(
        title: 'title:Base AI Models',
      ),
      ...modelItems,
    ];

    final renderBox = _modelSelectorKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final offset = renderBox.localToGlobal(Offset.zero);

    SelectorMenuHelper.showMenu<String>(
      context: context,
      items: items,
      selectedValue: _selectedModel,
      onItemSelected: (value) {
        setState(() {
          _selectedModel = value;
        });
      },
      offset: Offset(offset.dx, offset.dy + 36),
    );
  }

  Map<String, dynamic> get _currentModel {
    return _modelData.firstWhere((m) => m['name'] == _selectedModel, orElse: () => _modelData[0]);
  }

  void _copyMessage() {
    Clipboard.setData(ClipboardData(text: _generatedResponse!));

    // Show a SnackBar to confirm copy
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Response copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 32.0, bottom: 32.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sidebar button
                        Container(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          child: IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: _toggleSidebar,
                            tooltip: 'Toggle sidebar',
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                        ),

                        const Text('Email Details', style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),

                        // Original email
                        TextField(
                          controller: _emailController,
                          maxLines: 6,
                          decoration: const InputDecoration(
                            labelText: 'Original Email Content (required)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Subject, Sender, Receiver
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _subjectController,
                                decoration: const InputDecoration(
                                  labelText: 'Subject',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _senderController,
                                decoration: const InputDecoration(
                                  labelText: 'Sender',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _receiverController,
                                decoration: const InputDecoration(
                                  labelText: 'Receiver',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Main idea
                        TextField(
                          controller: _mainIdeaController,
                          decoration: const InputDecoration(
                            labelText: 'Main Idea (required)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Suggest idea
                        Row(
                          children: [
                            Expanded(
                              child: MouseRegion(
                                onEnter: (_) =>
                                    setState(() =>
                                    _isSuggestFocused = true),
                                onExit: (_) =>
                                    setState(() =>
                                    _isSuggestFocused = false),
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          _isSuggestFocused
                                              ? Colors.pink.shade400
                                              : Colors.pink.shade300,
                                          _isSuggestFocused
                                              ? Colors.purple.shade400
                                              : Colors.purple.shade300,
                                        ], // Gradient colors
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          24),
                                    ),
                                    child: InkWell(
                                      onTap: _loadingIdeas
                                          ? null
                                          : _fetchMainIdeas,
                                      child:
                                      _loadingIdeas
                                          ? const Center(
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white),
                                        ),
                                      )
                                          : Text('Suggest Reply Ideas',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.white)),
                                    )
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        const Text('Customization', style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),

                        // Style options
                        Row(
                          children: [
                            _buildDropdown('Length', _length, [
                              {'value': 'short', 'label': 'Short'},
                              {'value': 'medium', 'label': 'Medium'},
                              {'value': 'long', 'label': 'Long'}
                            ], (value) => _length = value),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                            children: [
                              _buildDropdown('Formality', _formality, [
                                {'value': 'casual', 'label': '👍🏻 Casual'},
                                {'value': 'neutral', 'label': '📄 Neutral'},
                                {'value': 'formal', 'label': '💼 Formal'},
                              ], (value) => _formality = value),
                              const SizedBox(width: 8),
                              _buildDropdown('Tone', _tone, [
                                {'value': 'witty', 'label': '😜 Witty'},
                                {'value': 'direct', 'label': '😳 Direct'},
                                {
                                  'value': 'personable',
                                  'label': '😋 Personable'
                                },
                                {
                                  'value': 'informational',
                                  'label': '🤓 Informational'
                                },
                                {
                                  'value': 'friendly',
                                  'label': '😀 Friendly'
                                },
                                {
                                  'value': 'confident',
                                  'label': '😎 Confident'
                                },
                                {'value': 'sincere', 'label': '😔 Sincere'},
                                {
                                  'value': 'enthusiastic',
                                  'label': '🤩 Enthusiastic'
                                },
                                {
                                  'value': 'optimistic',
                                  'label': '😇 Optimistic'
                                },
                                {
                                  'value': 'concerned',
                                  'label': '😟 Concerned'
                                },
                                {
                                  'value': 'empathetic',
                                  'label': '😢 Empathetic'
                                },
                              ], (value) => _tone = value),
                            ]
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildDropdown('Language', _language, [
                              {'value': '', 'label': 'Auto'},
                              {
                                'value': 'Vietnamese',
                                'label': 'Vietnamese'
                              },
                              {'value': 'English', 'label': 'English'},
                            ], (value) => _language = value),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Generate area
                        Row(
                          // Model selector
                          children: [
                            // MouseRegion(
                            //   onEnter: (_) => setState(() => _isAISelectorFocused = true),
                            //   onExit: (_) => setState(() => _isAISelectorFocused = false),
                            //   child: Container(
                            //     key: _modelSelectorKey,
                            //     margin: const EdgeInsets.only(right: 8.0),
                            //     padding: const EdgeInsets.symmetric(
                            //       horizontal: 12,
                            //       vertical: 8,
                            //     ),
                            //     decoration: BoxDecoration(
                            //       color:
                            //       _isAISelectorFocused
                            //           ? Colors.purple.shade100.withValues(alpha: 0.5)
                            //           : Colors.purple.shade50,
                            //       borderRadius: BorderRadius.circular(24),
                            //     ),
                            //     child: InkWell(
                            //       onTap: _showModelSelector,
                            //       hoverColor: Colors.transparent,
                            //       borderRadius: BorderRadius.circular(24),
                            //       child: Row(
                            //         mainAxisSize: MainAxisSize.min,
                            //         children: [
                            //           Icon(
                            //             _currentModel['icon'],
                            //             size: 20,
                            //             color: _currentModel['iconColor'],
                            //           ),
                            //           const SizedBox(width: 8),
                            //           Text(
                            //             _currentModel['name'],
                            //             style: const TextStyle(
                            //               fontSize: 14,
                            //               fontWeight: FontWeight.w500,
                            //             ),
                            //           ),
                            //           const SizedBox(width: 4),
                            //           const Icon(Icons.expand_more, size: 20),
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // ),

                            // Generate button
                            Expanded(
                              child: MouseRegion(
                                onEnter: (_) =>
                                    setState(() =>
                                    _isGenerateFocused = true),
                                onExit: (_) =>
                                    setState(() =>
                                    _isGenerateFocused = false),
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          _isGenerateFocused
                                              ? Colors.pink.shade400
                                              : Colors.pink.shade300,
                                          _isGenerateFocused
                                              ? Colors.purple.shade400
                                              : Colors.purple.shade300,
                                        ], // Gradient colors
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          24),
                                    ),
                                    child: InkWell(
                                      onTap: _loading
                                          ? null
                                          : _generateEmail,
                                      child:
                                      _loading
                                          ? const Center(
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white),
                                        ),
                                      )
                                          : Text('Generate Email Response',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.white)),
                                    )
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Output
                        if (_generatedResponse != null)
                          Expanded(
                            child: SingleChildScrollView(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.purple.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    SelectableText(
                                      _generatedResponse!,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: IconButton(
                                          icon: const Icon(Icons.copy, size: 24),
                                          onPressed: _copyMessage,
                                          tooltip: 'Copy',
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(
                                            minWidth: 24,
                                            minHeight: 24,
                                          ),
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              );
            }
          ),

          // Floating sidebar
          AppSidebar(
            isExpanded: true,
            isVisible: _isSidebarVisible,
            selectedIndex: 3,
            onItemSelected: (_) {},
            onToggleExpanded: () {},
            onClose: _closeSidebar,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String current, List<Map<String, String>> options, Function(String) onChanged) {
    return Expanded(
      child: DropdownButtonFormField<String>(
        value: current,
        items: options.map((opt) => DropdownMenuItem(
          value: opt['value'],
          child: Text(opt['label'] ?? opt['value']!),
        )).toList(),
        onChanged: (value) {
          if (value != null) setState(() => onChanged(value));
        },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
