import 'package:ai_chat/models/bot_model.dart';
import 'package:ai_chat/providers/bot_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

enum PlatformOption { messenger, slack, telegram }

class PublishBotDialog extends StatefulWidget {
  const PublishBotDialog({super.key});

  @override
  State<PublishBotDialog> createState() => _PublishBotDialogState();
}

class _PublishBotDialogState extends State<PublishBotDialog> {
  PlatformOption _selectedPlatform = PlatformOption.messenger;

  final TextEditingController botTokenController = TextEditingController();
  final TextEditingController pageIdController = TextEditingController();
  final TextEditingController appSecretController = TextEditingController();
  final TextEditingController clientIdController = TextEditingController();
  final TextEditingController clientSecretController = TextEditingController();
  final TextEditingController signingSecretController = TextEditingController();

  void handlePublish() {
    final botToken = botTokenController.text;
    final pageId = pageIdController.text;
    final appSecret = appSecretController.text;
    final clientId = clientIdController.text;
    final clientSecret = clientSecretController.text;
    final signingSecret = signingSecretController.text;

    switch (_selectedPlatform) {
      case PlatformOption.messenger:
        // Handle Messenger publish
        print(
          'Publishing to Messenger: token=$botToken, pageId=$pageId, appSecret=$appSecret',
        );
        break;
      case PlatformOption.slack:
        // Handle Slack publish
        print(
          'Publishing to Slack: token=$botToken, clientId=$clientId, clientSecret=$clientSecret, signingSecret=$signingSecret',
        );
        break;
      case PlatformOption.telegram:
        // Handle Telegram publish
        print('Publishing to Telegram: token=$botToken');
        break;
    }

    Navigator.of(context).pop();
  }

  Widget _buildPlatformForm() {
    InputDecoration inputDecoration = InputDecoration(
      isDense: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.purpleAccent, width: 2.0),
      ),
    );

    Widget label(String text, {bool isRequired = false}) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$text:',
              style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isRequired)
              const TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
          ],
        ),
      );
    }

    final BotModel? botModel = context.watch<BotProvider>().botModel;

    switch (_selectedPlatform) {
      case PlatformOption.messenger:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.blue.shade500,
                  ),
                  child: Text('1', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Messenger copy link',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Copy the following content to your Messenger app configuration page.',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            const Text(
              'Callback URL',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SelectableText(
                    'https://knowledge-api.jarvis.cx/kb-core/v1/hook/messenger/${botModel?.id ?? ''}',
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 12),
                  tooltip: 'Copy Callback URL',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(
                        text:
                            'https://knowledge-api.jarvis.cx/kb-core/v1/hook/messenger/${botModel?.id ?? ''}',
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Callback URL copied')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Verify Token',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: SelectableText(
                    'knowledge',
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 12),
                  tooltip: 'Copy Verify Token',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                  onPressed: () {
                    Clipboard.setData(const ClipboardData(text: 'knowledge'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Verify Token copied')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.blue.shade500,
                  ),
                  child: Text('2', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Messenger information',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            label('Bot Token', isRequired: true),
            const SizedBox(height: 8),
            TextField(
              controller: botTokenController,
              decoration: inputDecoration,
            ),
            const SizedBox(height: 16),
            label('Page ID', isRequired: true),
            const SizedBox(height: 8),
            TextField(
              controller: pageIdController,
              decoration: inputDecoration,
            ),
            const SizedBox(height: 16),
            label('App Secret', isRequired: true),
            const SizedBox(height: 8),
            TextField(
              controller: appSecretController,
              decoration: inputDecoration,
            ),
          ],
        );

      case PlatformOption.slack:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.blue.shade500,
                  ),
                  child: Text('1', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Slack copy link',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Copy the following content to your Slack app configuration page.',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            const Text(
              'OAuth2 Redirect URLs',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SelectableText(
                    'https://knowledge-api.jarvis.cx/kb-core/v1/bot-integration/slack/auth/${botModel?.id ?? ''}',
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 12),
                  tooltip: 'OAuth2 Redirect URLs',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(
                        text:
                            'https://knowledge-api.jarvis.cx/kb-core/v1/bot-integration/slack/auth/${botModel?.id ?? ''}',
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('OAuth2 Redirect URLs copied'),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Event Request URL',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SelectableText(
                    'https://knowledge-api.jarvis.cx/kb-core/v1/hook/slack/${botModel?.id ?? ''}',
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 12),
                  tooltip: 'Event Request URL',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(
                        text:
                            'https://knowledge-api.jarvis.cx/kb-core/v1/hook/slack/${botModel?.id ?? ''}',
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Event Request URL copied')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Slash Request URL',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SelectableText(
                    'https://knowledge-api.jarvis.cx/kb-core/v1/hook/slack/slash/${botModel?.id ?? ''}',
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 12),
                  tooltip: 'Slash Request URL',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(
                        text:
                            'https://knowledge-api.jarvis.cx/kb-core/v1/hook/slack/slash/${botModel?.id ?? ''}',
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Slash Request URL copied')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.blue.shade500,
                  ),
                  child: Text('2', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Slack information',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            label('Bot Token', isRequired: true),
            const SizedBox(height: 8),
            TextField(
              controller: botTokenController,
              decoration: inputDecoration,
            ),
            const SizedBox(height: 16),
            label('Client ID', isRequired: true),
            const SizedBox(height: 8),
            TextField(
              controller: clientIdController,
              decoration: inputDecoration,
            ),
            const SizedBox(height: 16),
            label('Client Secret', isRequired: true),
            const SizedBox(height: 8),
            TextField(
              controller: clientSecretController,
              decoration: inputDecoration,
            ),
            const SizedBox(height: 16),
            label('Signing Secret', isRequired: true),
            const SizedBox(height: 8),
            TextField(
              controller: signingSecretController,
              decoration: inputDecoration,
            ),
          ],
        );

      case PlatformOption.telegram:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.blue.shade500,
                  ),
                  child: Text('1', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Telegram information',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            label('Bot Token', isRequired: true),
            const SizedBox(height: 8),
            TextField(
              controller: botTokenController,
              decoration: inputDecoration,
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: 500,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  const Text(
                    'Publish bot',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Radio buttons
              Column(
                children: [
                  RadioListTile<PlatformOption>(
                    title: const Text('Messenger'),
                    value: PlatformOption.messenger,
                    groupValue: _selectedPlatform,
                    onChanged:
                        (value) => setState(() => _selectedPlatform = value!),
                  ),
                  RadioListTile<PlatformOption>(
                    title: const Text('Slack'),
                    value: PlatformOption.slack,
                    groupValue: _selectedPlatform,
                    onChanged:
                        (value) => setState(() => _selectedPlatform = value!),
                  ),
                  RadioListTile<PlatformOption>(
                    title: const Text('Telegram'),
                    value: PlatformOption.telegram,
                    groupValue: _selectedPlatform,
                    onChanged:
                        (value) => setState(() => _selectedPlatform = value!),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildPlatformForm(),
              const SizedBox(height: 16),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: handlePublish,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.pink.shade400,
                              Colors.purple.shade400,
                            ], // Gradient colors
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          'Publish',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
