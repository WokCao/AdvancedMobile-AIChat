import 'package:ai_chat/utils/knowledge_exception.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/knowledge_model.dart';
import '../../providers/knowledge_provider.dart';
import '../../services/data_source_service.dart';
import '../../widgets/ads/banner_ad_widget.dart';

class WebsiteScreen extends StatefulWidget {
  const WebsiteScreen({super.key});

  @override
  State<WebsiteScreen> createState() => _WebsiteScreenState();
}

class _WebsiteScreenState extends State<WebsiteScreen> {
  final _unitNameController = TextEditingController();
  final _urlController = TextEditingController();
  late bool _isLoading = false;

  void _handleUploadWebsite() async {
    if (_unitNameController.text.isEmpty || _urlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unit name and Web URL can't be empty!"),
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
    if (knowledgeModel == null) return;

    final dtService = Provider.of<DataSourceService>(context, listen: false);
    try {
      await dtService.createUnitWebURL(
        knowledgeId: knowledgeModel.id,
        unitName: _unitNameController.text,
        webUrl: _urlController.text,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        Navigator.popUntil(context, ModalRoute.withName('/unit'));
      }
    } on KnowledgeException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
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
        title: Text("Website URL"),
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
                  FaIcon(FontAwesomeIcons.globe, size: 32, color: Colors.blue),
                  SizedBox(width: 12),
                  Text(
                    'Website',
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
                            text: 'Web URL: ',
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
                      controller: _urlController,
                      decoration: InputDecoration(
                        hintText: 'https://example.com',
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
                          onPressed: _isLoading ? null : _handleUploadWebsite,
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
      bottomNavigationBar: BannerAdWidget(),
    );
  }
}
