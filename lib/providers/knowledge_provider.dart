import 'package:ai_chat/models/knowledge_model.dart';
import 'package:flutter/material.dart';

class KnowledgeProvider extends ChangeNotifier {
  late KnowledgeModel _selectedKnowledge;
  bool _wasUpdated = false;

  KnowledgeModel get selectedKnowledge => _selectedKnowledge;
  bool get wasUpdated => _wasUpdated;

  void setSelectedKnowledgeRow(
    KnowledgeModel selectedKnowledge, {
    bool updated = false,
  }) {
    _selectedKnowledge = selectedKnowledge;
    _wasUpdated = updated;
    notifyListeners();
  }

  void clearUpdateFlag() {
    _wasUpdated = false;
  }
}
