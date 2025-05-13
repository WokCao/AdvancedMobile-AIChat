import 'package:ai_chat/models/knowledge_model.dart';
import 'package:ai_chat/providers/bot_provider.dart';
import 'package:ai_chat/utils/get_api_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/bot_model.dart';
import '../../providers/knowledge_provider.dart';
import '../knowledge/remove_knowledge.dart';

class CreateBotDialog extends StatefulWidget {
  final bool isEditing;
  final String? botId;
  final String? initialName;
  final String? initialInstructions;
  final String? initialDescription;

  const CreateBotDialog({
    super.key,
    this.isEditing = false,
    this.botId,
    this.initialName,
    this.initialInstructions,
    this.initialDescription,
  });

  @override
  State<CreateBotDialog> createState() => _CreateBotDialogState();
}

class _CreateBotDialogState extends State<CreateBotDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isCreateFocused = false;
  bool _loading = false;
  bool _deleteKnowledgeLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName ?? '';
    _instructionsController.text = widget.initialInstructions ?? '';
    _descriptionController.text = widget.initialDescription ?? '';
  }

  Future<void> handleCreateUpdateBot() async {
    bool success = true;
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);

      final api = getKBApiService(context);

      if (widget.isEditing) {
        try {
          success = await api.updateBot(
            id: widget.botId!,
            assistantName: _nameController.text.trim(),
            instructions: _instructionsController.text.trim(),
            description: _descriptionController.text.trim(),
          );
        } catch (e) {
          success = false;
        }
      } else {
        try {
          final response = await api.createBot(
            assistantName: _nameController.text.trim(),
            instructions: _instructionsController.text.trim(),
            description: _descriptionController.text.trim(),
          );

          if (!mounted) return;

          final botId = response['id'];
          final List<KnowledgeModel> importedKnowledge = context.read<BotProvider>().importedKnowledge;

          success = true;

          for (KnowledgeModel knowledgeModel in importedKnowledge) {
            try {
              await api.importKnowledgeToAssistant(assistantId: botId, knowledgeId: knowledgeModel.id);
            } catch (e) {
              success = false;
              break;
            }
          }

          context.read<BotProvider>().clearAll();
        } catch (e) {
          success = false;
        }
      }

      if (success) {
        if (!mounted) return;
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Bot ${widget.isEditing ? "saved" : "created"} successfully",
            ),
          ),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Failed to ${widget.isEditing ? "save" : "create"} bot",
            ),
          ),
        );
      }
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final List<KnowledgeModel> importedKnowledge = context.watch<BotProvider>().importedKnowledge;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        child: Container(
          width: 480,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Text(
                    widget.isEditing ? 'Edit Your Bot' : 'Create Your Own Bot',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    color: Colors.grey,
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name field
                    Row(
                      children: [
                        const Text(
                          'Name',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '*',
                          style: TextStyle(
                            color: Colors.red[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText:
                            'Enter a name for your bot (e.g \'Customer Support Bot\')',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name for your bot';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Instructions field
                    Row(
                      children: [
                        const Text(
                          'Instructions',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(Optional)',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _instructionsController,
                      decoration: InputDecoration(
                        hintText:
                            'Describe how your bot should behave and respond. Add guidelines or specific rules if needed. (e.g \'Always respond with a pirate accent\')',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 16),

                    // Knowledge base section
                    if (!widget.isEditing) ...[
                      Row(
                        children: [
                          Text(
                            'Knowledge base',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(Optional)',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Enhance your bot\'s responses by adding custom knowledge.',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 100),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: importedKnowledge.length,
                          itemBuilder: (context, index) {
                            final item = importedKnowledge[index];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.yellow.shade300,
                                          Colors.orange.shade300,
                                        ],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.data_object_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      item.knowledgeName,
                                      style: const TextStyle(fontSize: 12),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  IconButton(
                                    onPressed: () {
                                      context
                                          .read<KnowledgeProvider>()
                                          .setSelectedKnowledgeRow(item);
                                      Navigator.pushNamed(context, '/units');
                                    },
                                    icon: const Icon(
                                      Icons.remove_red_eye_outlined,
                                      size: 18,
                                    ),
                                    padding: const EdgeInsets.all(4.0),
                                    constraints: const BoxConstraints(),
                                    tooltip: 'View',
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (_) => RemoveKnowledge(
                                          handleDeleteKnowledge: (String _) {
                                            setState(() {
                                              _deleteKnowledgeLoading = true;
                                            });

                                            context
                                                .read<BotProvider>()
                                                .removeAKnowledge(item);
                                            setState(() {
                                              _deleteKnowledgeLoading = false;
                                            });
                                          },
                                        ),
                                      );
                                    },
                                    icon:
                                    _deleteKnowledgeLoading
                                        ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.grey,
                                        ),
                                      ),
                                    )
                                        : const Icon(Icons.delete_outline, size: 18),
                                    padding: const EdgeInsets.all(4.0),
                                    constraints: const BoxConstraints(),
                                    tooltip: 'Remove',
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity, // Make button full width
                        child: OutlinedButton.icon(
                          onPressed: () {
                            context.read<BotProvider>().clearAll();
                            context.read<BotProvider>().setSelectedBotModel(botModel: BotModel.empty(id: "-1. Temporary bot"));
                            Navigator.pushNamed(context, '/knowledge');
                          },
                          icon: Icon(Icons.add, color: Colors.purple.shade700),
                          label: const Text('Add knowledge source'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.purple.shade700,
                            side: BorderSide(color: Colors.purple.shade200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Description field
                    Row(
                      children: [
                        const Text(
                          'Description',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(Optional)',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        hintText:
                            'Enter a description for your bot (e.g \'A helpful customer support assistant\')',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                      maxLines: 4,
                    ),
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
                              vertical: 8
                            ),
                            minimumSize: Size(0, 0)
                          ),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 12),
                        MouseRegion(
                          onEnter:
                              (_) => setState(() => _isCreateFocused = true),
                          onExit:
                              (_) => setState(() => _isCreateFocused = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _isCreateFocused
                                      ? Colors.pink.shade400
                                      : Colors.pink.shade300,
                                  _isCreateFocused
                                      ? Colors.purple.shade400
                                      : Colors.purple.shade300,
                                ], // Gradient colors
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: InkWell(
                              onTap: handleCreateUpdateBot,
                              child:
                                  _loading
                                      ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                      : Text(
                                        widget.isEditing ? 'Save' : 'Create',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                            ),
                          ),
                        ),
                      ],
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
