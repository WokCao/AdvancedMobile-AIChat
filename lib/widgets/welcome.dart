import 'package:ai_chat/models/prompt_model.dart';
import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../utils/get_api_utils.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  bool _isTrialFocused = false;
  final List<PromptModel> _suggestedPrompts = [];

  Future<void> _fetchPublicPrompts() async {
    final apiService = getApiService(context);
    final data = await apiService.getPublicPrompts(
      offset: 0,
      limit: 5
    );

    if (!mounted) return;

    setState(() {
      _suggestedPrompts.addAll(
        (data['items'] as List)
            .map((item) => PromptModel.fromJson(item))
            .toList(),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchPublicPrompts();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 18.0, right: 18.0, bottom: 18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greetings
          Icon(Icons.waving_hand, color: Colors.purple.shade300, size: 40),
          const SizedBox(height: 4),
          Text(
            'Hi, good afternoon!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "I'm ChatGEM, your personal assistant.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),

          // Pro Version Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Upgrade to the Pro version for unlimited access with a 1-month free trial!',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: MouseRegion(
                    onEnter: (_) => setState(() => _isTrialFocused = true),
                    onExit: (_) => setState(() => _isTrialFocused = false),
                    child: Container(
                        margin: const EdgeInsets.only(left: 16.0),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _isTrialFocused
                                  ? Colors.pink.shade400
                                  : Colors.pink.shade300,
                              _isTrialFocused
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
                            // Handle upgrade
                          },
                          child: const Text('Start Free Trial', style: TextStyle(color: Colors.white)),
                        )
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),

          // Prompts Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Don't know what to say? Use a prompt!",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              TextButton(
                onPressed: () {
                  /// Handle view all prompts
                  Navigator.pushNamed(context, '/prompts');
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.purple,
                ),
                child: const Text('View all'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 90,
            child: ListView(
              children: _suggestedPrompts.map((PromptModel prompt) => _buildSectionWithArrow(
                title: prompt.title,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(
                        showUsePrompt: true,
                        promptModel: prompt,
                      ),
                    ),
                  );
                },
                compact: true,
              )).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionWithArrow({
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool compact = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: compact ? 8 : 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade400,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward,
                size: 20,
                color: Colors.purple,
              ),
            ],
          ),
        ),
      ),
    );
  }
}