import 'package:ai_chat/models/knowledge_model.dart';
import 'package:ai_chat/providers/knowledge_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateKnowledgeDialog extends StatefulWidget {
  final Function(String knowledgeName, String description) onSubmit;
  final String type;
  const CreateKnowledgeDialog({super.key, required this.onSubmit, required this.type});

  @override
  State<CreateKnowledgeDialog> createState() => _CreateKnowledgeDialogState();
}

class _CreateKnowledgeDialogState extends State<CreateKnowledgeDialog> {
  late KnowledgeModel? selectedKnowledgeModel;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  bool _isCreateFocused = false;

  @override
  void initState() {
    super.initState();
    selectedKnowledgeModel = Provider.of<KnowledgeProvider>(context, listen: false).selectedKnowledge;
    _nameController = TextEditingController(text: selectedKnowledgeModel?.knowledgeName ?? '');
    _descriptionController = TextEditingController(text: selectedKnowledgeModel?.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        _nameController.text,
        _descriptionController.text,
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: Container(
          width: 480,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Text(
                    widget.type == 'Create' ? 'Create New Knowledge' : 'Update Knowledge',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                    maxLines: 4,
                  ),
                  SizedBox(height: 16,),
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
                        onEnter: (_) => setState(() => _isCreateFocused = true),
                        onExit: (_) => setState(() => _isCreateFocused = false),
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
                              onTap: _handleSubmit,
                              child: const Text('Confirm', style: TextStyle(color: Colors.white)),
                            )
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        colors: [Colors.yellow.shade300, Colors.orange.shade300],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                    ),
                    child: Icon(Icons.data_object_outlined, color: Colors.white, size: 64,),
                  )
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
                          'Knowledge Name',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
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
                          return 'Please enter a name for your knowledge';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'Knowledge description',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                      maxLines: 4,
                    ),
                    SizedBox(height: 16),
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
                            minimumSize: Size(0, 0),
                          ),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 12),
                        MouseRegion(
                          onEnter: (_) => setState(() => _isCreateFocused = true),
                          onExit: (_) => setState(() => _isCreateFocused = false),
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
                                onTap: () {
                                  // Handle create bot
                                },
                                child: const Text('Confirm', style: TextStyle(color: Colors.white)),
                              )
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