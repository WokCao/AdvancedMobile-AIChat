import 'package:flutter/material.dart';

import '../screens/home_screen.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  bool _isTrialFocused = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greetings
          Text(
            '👋',
            style: TextStyle(fontSize: 32),
          ),
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

          // Prompt Suggestions
          ...[
            'Grammar corrector',
            'Learn Code FAST!',
            'Story generator',
          ].map((prompt) => _buildSectionWithArrow(
            title: prompt,
            onTap: () {
              /// Handle selecting prompt
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(showUsePrompt: true),
                ),
              );
            },
            compact: true,
          )),
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
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
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