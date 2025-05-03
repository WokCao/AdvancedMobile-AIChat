import 'package:ai_chat/utils/knowledge_exception.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/knowledge_model.dart';
import '../../providers/knowledge_provider.dart';
import '../../services/data_source_service.dart';

class SlackScreen extends StatefulWidget {
  const SlackScreen({super.key});

  @override
  State<SlackScreen> createState() => _SlackScreenState();
}

class _SlackScreenState extends State<SlackScreen> {
  final _unitNameController = TextEditingController();
  final _slackWorkspaceController = TextEditingController();
  final _slackBotTokenController = TextEditingController();
  late bool _isLoading = false;

  void _handleUploadSlack() async {
    if (_unitNameController.text.isEmpty ||
        _slackWorkspaceController.text.isEmpty ||
        _slackBotTokenController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Unit name, Slack workspace and Slack bot token can't be empty!",
          ),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    KnowledgeModel? knowledgeModel =
        Provider.of<KnowledgeProvider>(
          context,
          listen: false,
        ).selectedKnowledge;

    final dtService = Provider.of<DataSourceService>(context, listen: false);
    if (knowledgeModel == null) return;

    try {
      await dtService.createUnitSlack(
        knowledgeId: knowledgeModel.id,
        unitName: _unitNameController.text,
        slackWorkspace: _slackWorkspaceController.text,
        slackBotToken: _slackBotTokenController.text,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        Navigator.popUntil(context, ModalRoute.withName('/unit'));
      }
    } on KnowledgeException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Slack"),
        backgroundColor: Colors.purple.shade200,
      ),
      body: Center(
        child: Container(
          width: 800,
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.slack, size: 32, color: Colors.blue),
                  SizedBox(width: 12),
                  Text(
                    'Slack',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Name: ',
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: '*',
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: _unitNameController,
                      decoration: InputDecoration(
                        hintText: 'Example',
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.purpleAccent,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Workspace: ',
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: '*',
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: _slackWorkspaceController,
                      decoration: InputDecoration(
                        hintText: 'Your workspace',
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.purpleAccent,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Bot token: ',
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: '*',
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: _slackBotTokenController,
                      decoration: InputDecoration(
                        hintText: 'Your bot token',
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.purpleAccent,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 72),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.pink.shade200,
                              Colors.purple.shade200,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            _handleUploadSlack();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child:
                              _isLoading
                                  ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Text(
                                    'Connect',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                        ),
                      ),
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
