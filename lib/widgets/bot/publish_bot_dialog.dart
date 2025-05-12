import 'package:ai_chat/models/bot_model.dart';
import 'package:ai_chat/providers/bot_provider.dart';
import 'package:ai_chat/services/bot_integration_service.dart';
import 'package:ai_chat/utils/knowledge_exception.dart';
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
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  bool containSlack = false, containMessenger = false, containTelegram = false;

  void _clearAllControllers() {
    botTokenController.clear();
    pageIdController.clear();
    appSecretController.clear();
    clientIdController.clear();
    clientSecretController.clear();
    signingSecretController.clear();
  }

  Future<void> getConfiguration() async {
    final BotModel? botModel = context.read<BotProvider>().botModel;
    try {
      setState(() {
        _isLoading = true;
      });
      final List<dynamic> data = await Provider.of<BotIntegrationService>(
        context,
        listen: false,
      ).getConfig(assistantId: botModel!.id);

      for (dynamic config in data) {
        if (config['type'] == 'slack') {
          setState(() {
            containSlack = true;
          });
        } else if (config['type'] == 'messenger') {
          setState(() {
            containMessenger = true;
          });
        } else if (config['type'] == 'telegram') {
          setState(() {
            containTelegram = true;
          });
        }
      }

      setState(() {
        _isLoading = false;
      });
    } on KnowledgeException catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), duration: Duration(seconds: 2)),
      );
    }
  }

  @override
  void initState() {
    getConfiguration();
    super.initState();
  }

  Future<void> handleDisconnect() async {
    setState(() {
      _isLoading = true;
    });
    final BotModel? botModel = context.read<BotProvider>().botModel;

    if (botModel == null) return;

    try {
      String type = _selectedPlatform.name;
      await Provider.of<BotIntegrationService>(
        context,
        listen: false,
      ).disconnectIntegration(assistantId: botModel.id, type: type);

      setState(() {
        _isLoading = false;
        if (type == 'slack') {
          containSlack = false;
        } else if (type == 'messenger') {
          containMessenger = false;
        } else if (type == 'telegram') {
          containTelegram = false;
        }
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Disconnected successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } on KnowledgeException catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), duration: Duration(seconds: 2)),
      );
    }
  }

  Future<void> handlePublish() async {
    final botToken = botTokenController.text;
    final pageId = pageIdController.text;
    final appSecret = appSecretController.text;
    final clientId = clientIdController.text;
    final clientSecret = clientSecretController.text;
    final signingSecret = signingSecretController.text;
    final BotModel? botModel = context.read<BotProvider>().botModel;

    if (botModel == null) return;
    setState(() {
      _isLoading = true;
    });

    if (!_formKey.currentState!.validate()) {
      setState(() => _isLoading = false);
      return;
    }

    switch (_selectedPlatform) {
      case PlatformOption.messenger:
        final botIntegrationService = Provider.of<BotIntegrationService>(
          context,
          listen: false,
        );
        try {
          await botIntegrationService.messengerPublish(
            assistantId: botModel.id,
            botToken: botToken,
            pageId: pageId,
            appSecret: appSecret,
          );

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Bot has been published to Messenger successfully!',
              ),
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.of(context).pop();
        } on KnowledgeException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message),
              duration: const Duration(seconds: 2),
            ),
          );
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
        break;

      case PlatformOption.slack:
        final botIntegrationService = Provider.of<BotIntegrationService>(
          context,
          listen: false,
        );
        try {
          await botIntegrationService.slackPublish(
            assistantId: botModel.id,
            botToken: botToken,
            clientId: clientId,
            clientSecret: clientSecret,
            signingSecret: signingSecret,
          );

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bot has been published to Slack successfully!'),
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.of(context).pop();
        } on KnowledgeException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message),
              duration: const Duration(seconds: 2),
            ),
          );
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
        break;

      case PlatformOption.telegram:
        final botIntegrationService = Provider.of<BotIntegrationService>(
          context,
          listen: false,
        );
        try {
          await botIntegrationService.telegramPublish(
            assistantId: botModel.id,
            botToken: botToken,
          );

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bot has been published to Telegram successfully!'),
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.of(context).pop();
        } on KnowledgeException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message),
              duration: const Duration(seconds: 2),
            ),
          );
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
        break;
    }
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
        return _isLoading
            ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
            : !containMessenger
            ? Column(
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
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
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
                        Clipboard.setData(
                          const ClipboardData(text: 'knowledge'),
                        );
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
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      label('Bot Token', isRequired: true),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: botTokenController,
                        decoration: inputDecoration,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Field Bot Token is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      label('Page ID', isRequired: true),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: pageIdController,
                        decoration: inputDecoration,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Field Page Id is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      label('App Secret', isRequired: true),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: appSecretController,
                        decoration: inputDecoration,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Field App Secret is required';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )
            : SizedBox(
              child: Text(
                'Bot has been integrated to Messenger',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );

      case PlatformOption.slack:
        return _isLoading
            ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
            : !containSlack
            ? Column(
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
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
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
                          const SnackBar(
                            content: Text('Event Request URL copied'),
                          ),
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
                          const SnackBar(
                            content: Text('Slash Request URL copied'),
                          ),
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
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      label('Bot Token', isRequired: true),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: botTokenController,
                        decoration: inputDecoration,
                        validator:
                            (value) =>
                                value == null || value.trim().isEmpty
                                    ? 'Field Bot Token is required'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      label('Client ID', isRequired: true),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: clientIdController,
                        decoration: inputDecoration,
                        validator:
                            (value) =>
                                value == null || value.trim().isEmpty
                                    ? 'Field Client ID is required'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      label('Client Secret', isRequired: true),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: clientSecretController,
                        decoration: inputDecoration,
                        validator:
                            (value) =>
                                value == null || value.trim().isEmpty
                                    ? 'Field Client Secret is required'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      label('Signing Secret', isRequired: true),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: signingSecretController,
                        decoration: inputDecoration,
                        validator:
                            (value) =>
                                value == null || value.trim().isEmpty
                                    ? 'Field Signing Secret is required'
                                    : null,
                      ),
                    ],
                  ),
                ),
              ],
            )
            : SizedBox(
              child: Text(
                'Bot has been integrated to Slack',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );

      case PlatformOption.telegram:
        return _isLoading
            ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
            : !containTelegram
            ? Column(
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
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      label('Bot Token', isRequired: true),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: botTokenController,
                        decoration: inputDecoration,
                        validator:
                            (value) =>
                                value == null || value.trim().isEmpty
                                    ? 'Field Bot Token is required'
                                    : null,
                      ),
                    ],
                  ),
                ),
              ],
            )
            : SizedBox(
              child: Text(
                'Bot has been integrated to Telegram',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
                    onChanged: (value) {
                      setState(() {
                        _selectedPlatform = value!;
                        _clearAllControllers();
                      });
                    },
                  ),
                  RadioListTile<PlatformOption>(
                    title: const Text('Slack'),
                    value: PlatformOption.slack,
                    groupValue: _selectedPlatform,
                    onChanged: (value) {
                      setState(() {
                        _selectedPlatform = value!;
                        _clearAllControllers();
                      });
                    },
                  ),
                  RadioListTile<PlatformOption>(
                    title: const Text('Telegram'),
                    value: PlatformOption.telegram,
                    groupValue: _selectedPlatform,
                    onChanged: (value) {
                      setState(() {
                        _selectedPlatform = value!;
                        _clearAllControllers();
                      });
                    },
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
                        vertical: 6,
                      ),
                      minimumSize: Size(0, 0),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap:
                        _selectedPlatform == PlatformOption.slack &&
                                    containSlack ||
                                _selectedPlatform == PlatformOption.messenger &&
                                    containMessenger ||
                                _selectedPlatform == PlatformOption.telegram &&
                                    containTelegram
                            ? handleDisconnect
                            : handlePublish,
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
                        child:
                            _isLoading
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                : Text(
                                  _selectedPlatform == PlatformOption.slack &&
                                              containSlack ||
                                          _selectedPlatform ==
                                                  PlatformOption.messenger &&
                                              containMessenger ||
                                          _selectedPlatform ==
                                                  PlatformOption.telegram &&
                                              containTelegram
                                      ? 'Disconnect'
                                      : 'Publish',
                                  style: const TextStyle(color: Colors.white),
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
