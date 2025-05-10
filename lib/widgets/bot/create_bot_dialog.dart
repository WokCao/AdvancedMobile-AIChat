import 'package:ai_chat/utils/get_api_utils.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName ?? '';
    _instructionsController.text = widget.initialInstructions ?? '';
    _descriptionController.text = widget.initialDescription ?? '';
  }

  @override
  Widget build(BuildContext context) {
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
                      SizedBox(
                        width: double.infinity, // Make button full width
                        child: OutlinedButton.icon(
                          onPressed: () {
                            /// Handle adding knowledge source
                            Navigator.pushNamed(context, '/source');
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
                              vertical: 12,
                            ),
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
                              vertical: 6,
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
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => _loading = true);

                                  final api = getKBApiService(context);
                                  final success =
                                      widget.isEditing
                                          ? await api.updateBot(
                                            id: widget.botId!,
                                            assistantName:
                                                _nameController.text.trim(),
                                            instructions:
                                                _instructionsController.text
                                                    .trim(),
                                            description:
                                                _descriptionController.text
                                                    .trim(),
                                          )
                                          : await api.createBot(
                                            assistantName:
                                                _nameController.text.trim(),
                                            instructions:
                                                _instructionsController.text
                                                    .trim(),
                                            description:
                                                _descriptionController.text
                                                    .trim(),
                                          );

                                  if (success) {
                                    Navigator.of(context).pop(true);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Bot ${widget.isEditing ? "saved" : "created"} successfully",
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Failed to ${widget.isEditing ? "save" : "create"} bot",
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
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
