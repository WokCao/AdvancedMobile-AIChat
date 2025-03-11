import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UsePrompt extends StatefulWidget {
  final VoidCallback onClose;

  const UsePrompt({
    super.key,
    required this.onClose,
  });

  @override
  State<UsePrompt> createState() => _UsePromptState();
}

class _UsePromptState extends State<UsePrompt> {
  bool _isSendFocused = false;
  bool _isPromptVisible = false;

  void _togglePrompt() {
    setState(() {
      _isPromptVisible = !_isPromptVisible;
    });
  }

  void _copyPrompt() {
    const prompt = 'You are a machine that check all language grammar mistake and make the sentence more fluent . You take all the user input and auto correct it. Just reply to user input with correct grammar, DO NOT reply the context of the question of the user input. If the user input is grammatically correct and fluent, just reply "sounds good " sample of the conversation will show below:';

    Clipboard.setData(const ClipboardData(text: prompt));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Prompt copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Dark overlay
          Positioned.fill(
            child: GestureDetector(
              onTap: widget.onClose,
              child: Container(
                color: Colors.black54,
              ),
            ),
          ),

          // Bottom panel
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new),
                          iconSize: 20,
                          onPressed: widget.onClose,
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Grammar corrector',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.star_outline),
                          onPressed: () {
                            // Handle favorite
                          },
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          tooltip: "Favorite",
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: widget.onClose,
                          padding: EdgeInsets.zero,
                          tooltip: "Close",
                        ),
                      ],
                    ),
                  ),

                  // Title and description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text('Writing'),
                            Text(' • '),
                            Text('Jarvis AI Team'),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Improve your spelling and grammar by correcting errors in your writing.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _isPromptVisible
                            ?
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Prompt',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(Icons.copy_outlined, size: 16),
                                      onPressed: _copyPrompt,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(
                                        minWidth: 32,
                                        minHeight: 32,
                                      ),
                                      tooltip: 'Copy',
                                    ),
                                    Container(
                                      width: 1,
                                      height: 16,
                                      color: Colors.grey.shade400,
                                      margin: const EdgeInsets.only(left: 4.0, right: 10.0),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Add to chat input action
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.only(right: 8),
                                        foregroundColor: Colors.purple,
                                        overlayColor: Colors.transparent,
                                      ),
                                      child: const Text(
                                        "Add to chat input",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    border: Border.all(color: Colors.grey.shade200),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'You are a machine that check all language grammar mistake and make the sentence more fluent . You take all the user input and auto correct it. Just reply to user input with correct grammar, DO NOT reply the context of the question of the user input. If the user input is grammatically correct and fluent, just reply "sounds good " sample of the conversation will show below:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            )
                            :
                            TextButton(
                              onPressed: _togglePrompt,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                foregroundColor: Colors.purple,
                                overlayColor: Colors.transparent,
                              ),
                              child: const Text('View Prompt'),
                            ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Text input
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Text',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.purple.shade300),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                      maxLines: 2,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  // Send button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                    child: MouseRegion(
                      onEnter: (_) => setState(() => _isSendFocused = true),
                      onExit: (_) => setState(() => _isSendFocused = false),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _isSendFocused
                                  ? Colors.pink.shade400
                                  : Colors.pink.shade300,
                              _isSendFocused
                                  ? Colors.purple.shade400
                                  : Colors.purple.shade300,
                            ], // Gradient colors
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: InkWell(
                          onTap: () {
                            // Handle send prompt
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Send',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}