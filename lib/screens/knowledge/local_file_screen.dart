import 'dart:io';

import 'package:ai_chat/models/knowledge_model.dart';
import 'package:ai_chat/services/data_source_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:provider/provider.dart';

import '../../providers/knowledge_provider.dart';
import '../../widgets/knowledge/file_item.dart';

class LocalFileScreen extends StatefulWidget {
  const LocalFileScreen({super.key});

  @override
  State<LocalFileScreen> createState() => _LocalFileScreenState();
}

class _LocalFileScreenState extends State<LocalFileScreen> {
  final List<PlatformFile> _selectedFiles = [];

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'c', 'cpp', 'docx', 'html', 'java', 'json', 'md',
        'pdf', 'php', 'pptx', 'py', 'rb', 'tex', 'txt',
      ],
    );

    if (result != null) {
      setState(() {
        _selectedFiles.addAll(result.files);
      });
    }
  }

  void _removeFile(PlatformFile file) {
    setState(() {
      _selectedFiles.remove(file);
    });
  }

  void _handleConnectFile() async {
    bool allSuccess = true;

    KnowledgeModel knowledgeModel = Provider.of<KnowledgeProvider>(context, listen: false).selectedKnowledge;
    final dtService = Provider.of<DataSourceService>(context, listen: false);

    for (PlatformFile platformFile in _selectedFiles) {
      final file = File(platformFile.path!);
      final response = await dtService.createUnitFileType(knowledgeId: knowledgeModel.id, file: file);

      if (!response["success"]) {
        allSuccess = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload ${file.path.split("/").last}. Please try again.'),
            duration: Duration(seconds: 3),
          ),
        );
        continue;
      }
    }

    if (allSuccess) {
      _selectedFiles.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All files uploaded successfully!'),
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Local files"),
        backgroundColor: Colors.purple.shade200,
      ),
      body: Center(
        child: Container(
          width: 800,
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
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
                children: [
                  FaIcon(
                    FontAwesomeIcons.fileLines,
                    size: 32,
                    color: Colors.grey.shade800,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Local file',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  Spacer(),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Tooltip(
                      message: 'How to connect to local file',
                      child: GestureDetector(
                        onTap: () {
                          /// Move to instruction page
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: FaIcon(
                            FontAwesomeIcons.fileWord,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Upload local file: ',
                      style: TextStyle(color: Colors.grey.shade800, fontSize: 14),
                    ),
                    TextSpan(
                      text: '*',
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _pickFile,
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(8),
                    color: Colors.grey.withValues(alpha: 0.5),
                    strokeWidth: 1,
                    dashPattern: [6, 4],
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 32,
                        horizontal: 24,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.folder_open_rounded,
                            size: 40,
                            color: Colors.purple.shade500,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Click this area to upload',
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Support for a single or bulk upload. Strictly prohibit from uploading company data or other band files',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              SizedBox(
                height: 5 * 36.0,
                child: ListView.builder(
                  controller: ScrollController(keepScrollOffset: false),
                  itemCount: _selectedFiles.length,
                  itemBuilder: (context, index) {
                    final file = _selectedFiles[index];
                    return FileItem(file: file, removeFile: _removeFile,);
                  },
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 72),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.pink.shade200, Colors.purple.shade200],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton(
                    onPressed: _handleConnectFile,
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
                    child: Text(
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
      ),
    );
  }
}
