import 'package:flutter/material.dart';

class BotPlaygroundScreen extends StatefulWidget {
  const BotPlaygroundScreen({super.key});

  @override
  State<BotPlaygroundScreen> createState() => _BotPlaygroundScreenState();
}

class _BotPlaygroundScreenState extends State<BotPlaygroundScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isMessageHasText = false;
  final TextEditingController _personaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    final text = _messageController.text;
    if (text.isNotEmpty) {
      setState(() {
        _isMessageHasText = true;
      });
    }
    else {
      setState(() {
        _isMessageHasText = false;
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top Header
          Container(
            padding: const EdgeInsets.only(top: 12.0, bottom: 16.0, left: 16.0, right: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              children: [
                // WordBot Logo and Title
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      padding: EdgeInsets.all(4.0),
                      constraints: BoxConstraints(),
                      icon: Icon(
                          Icons.arrow_back_ios_new,
                          size: 20,
                          color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.smart_toy_outlined,
                      size: 48,
                      color: Colors.purple.shade200,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bot 1',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade50,
                            border: Border.all(color: Colors.purple.shade200),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_2_outlined,
                                size: 14,
                                color: Colors.purple.shade700,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Personal',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.purple.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                // Action Buttons
                TextButton.icon(
                  onPressed: () {
                    // Handle read docs
                  },
                  icon: const Icon(Icons.description_outlined),
                  label: const Text('Docs'),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {
                    // Handle publish bot
                  },
                  icon: const Icon(Icons.upload, size: 16, color: Colors.white),
                  label: const Text('Publish'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade400,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Row(
              children: [
                // Sidebar
                Column(
                  children: [
                    // Develop
                    Container(
                      width: 280,
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Develop Header
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              border: Border(
                                bottom: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Develop',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Persona & Prompt',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.check_circle_outline,
                                      size: 18,
                                      color: Colors.purple,
                                    )
                                  ],
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: _personaController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    hintText: 'Design the bot\'s persona, features and workflow using natural language.',
                                    hintStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.transparent),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.transparent),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.transparent),
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                  maxLines: null,
                                  minLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Knowledge
                    Expanded(
                      child: Container(
                        width: 280,
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Knowledge Header
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                border: Border(
                                  top: BorderSide(color: Colors.grey.shade300),
                                  bottom: BorderSide(color: Colors.grey.shade300),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Knowledge',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0, right: 8.0),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      gradient: LinearGradient(
                                        colors: [Colors.yellow.shade300, Colors.orange.shade300],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                      ),
                                    ),
                                    child: Icon(Icons.data_object_outlined, color: Colors.white),
                                  ),
                                  const SizedBox(width: 8),
                                  const Expanded(
                                    child: Text(
                                      'Bot 1\'s Knowledge Base - 1741584290659',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  IconButton(
                                    onPressed: () {
                                      /// Handle view knowledge
                                    },
                                    icon: const Icon(
                                      Icons.remove_red_eye_outlined,
                                      size: 18,
                                    ),
                                    padding: EdgeInsets.all(4.0),
                                    constraints: BoxConstraints(),
                                    tooltip: 'View',
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      /// Handle remove knowledge
                                    },
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      size: 18,
                                    ),
                                    padding: EdgeInsets.all(4.0),
                                    constraints: BoxConstraints(),
                                    tooltip: 'Remove',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Chat Area
                Expanded(
                  child: Column(
                    children: [
                      // Preview Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Preview',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Chat Content
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Icon(
                                  Icons.smart_toy_outlined,
                                  size: 36,
                                  color: Colors.purple.shade300,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Bot 1',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Start a conversation with the assistant',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'by typing a message in the input box below.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Message Input
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.purple.shade300,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  // Handle new thread
                                },
                                padding: EdgeInsets.all(8.0),
                                constraints: BoxConstraints(),
                                icon: Icon(
                                  Icons.message,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                tooltip: 'New thread',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                decoration: InputDecoration(
                                  hintText: 'Type a message...',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: const BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: const BorderSide(color: Colors.purple),
                                  ),
                                ),
                                maxLines: null,
                                minLines: 1,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              decoration: BoxDecoration(
                                color: _isMessageHasText ? Colors.purple.shade300 : Colors.grey,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: IconButton(
                                onPressed: _isMessageHasText ? () {
                                  // Handle send message
                                } : null,
                                padding: EdgeInsets.all(8.0),
                                constraints: BoxConstraints(),
                                icon: Icon(
                                  Icons.send,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                tooltip: 'Send message',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}