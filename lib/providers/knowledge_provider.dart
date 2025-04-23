import 'package:ai_chat/models/knowledge_model.dart';
import 'package:flutter/material.dart';

class KnowledgeProvider extends ChangeNotifier {
  late KnowledgeModel _selectedKnowledge;

  KnowledgeModel get selectedKnowledge => _selectedKnowledge;

  void setSelectedKnowledgeRow(KnowledgeModel selectedKnowledge) {
    _selectedKnowledge = selectedKnowledge;
    notifyListeners();
  }
}
