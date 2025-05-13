import 'package:ai_chat/utils/knowledge_exception.dart';
import 'package:ai_chat/widgets/ads/banner_ad_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/knowledge_model.dart';
import '../../providers/knowledge_provider.dart';
import '../../services/data_source_service.dart';

class ConfluenceScreen extends StatefulWidget {
  const ConfluenceScreen({super.key});

  @override
  State<ConfluenceScreen> createState() => _ConfluenceScreenState();
}

class _ConfluenceScreenState extends State<ConfluenceScreen> {
  final _unitNameController = TextEditingController();
  final _wikiPageUrlController = TextEditingController();
  final _confluenceUsernameController = TextEditingController();
  final _confluenceAccessTokenController = TextEditingController();
  bool _isLoading = false;

  void _handleUploadConfluence() async {
    if (_unitNameController.text.isEmpty ||
        _wikiPageUrlController.text.isEmpty ||
        _confluenceUsernameController.text.isEmpty ||
        _confluenceAccessTokenController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Unit name, Wiki page URL, Confluence username and Confluence access token can't be empty!",
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
        Provider.of<KnowledgeProvider>(context, listen: false).selectedKnowledge;

    if (knowledgeModel == null) return;

    final dtService = Provider.of<DataSourceService>(context, listen: false);
    try {
      await dtService.createUnitConfluence(
        knowledgeId: knowledgeModel.id,
        unitName: _unitNameController.text,
        wikiPageUrl: _wikiPageUrlController.text,
        confluenceUsername: _confluenceUsernameController.text,
        confluenceAccessToken: _confluenceAccessTokenController.text,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        context.read<KnowledgeProvider>().updated();
        Navigator.popUntil(context, ModalRoute.withName('/units'));
      }
    } on KnowledgeException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message
          ),
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
      body: SingleChildScrollView(
        child: Center(
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
                    FaIcon(FontAwesomeIcons.confluence, size: 32, color: Colors.blue),
                    SizedBox(width: 12),
                    Text(
                      'Confluence',
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
                              text: 'Wiki page URL: ',
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
                        controller: _wikiPageUrlController,
                        decoration: InputDecoration(
                          hintText: 'https://your-domain.atlassian.net',
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
                              text: 'Confluence username: ',
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
                        controller: _confluenceUsernameController,
                        decoration: InputDecoration(
                          hintText: "Your confluence username (user's email)",
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
                              text: 'Confluence access token: ',
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
                        controller: _confluenceAccessTokenController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Your confluence access token',
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
                            onPressed:
                            _isLoading ? null : _handleUploadConfluence,
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
                                  Colors.purple.shade200,
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
      ),
      bottomNavigationBar: BannerAdWidget(),
    );
  }
}
