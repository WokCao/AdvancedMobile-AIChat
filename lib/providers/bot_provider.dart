import 'dart:core';

import 'package:ai_chat/models/knowledge_model.dart';
import 'package:flutter/material.dart';

import '../models/bot_model.dart';

class BotProvider extends ChangeNotifier {
  BotModel? _botModel;
  List<KnowledgeModel> _importedKnowledge = [];

  BotModel? get botModel => _botModel;
  List<KnowledgeModel> get importedKnowledge => _importedKnowledge;

  void setSelectedBotModel({ required BotModel? botModel }) {
    _botModel = botModel;
    notifyListeners();
  }

  void setImportedKnowledge({ required List<KnowledgeModel> importedKnowledge }) {
    _importedKnowledge.addAll(importedKnowledge);
    notifyListeners();
  }

  void addAKnowledge(KnowledgeModel knowledgeModel) {
    _importedKnowledge.add(knowledgeModel);
    notifyListeners();
  }

  void removeAKnowledge(KnowledgeModel knowledgeModel) {
    _importedKnowledge.removeWhere((existing) => existing.id == knowledgeModel.id);
    notifyListeners();
  }

  void clearAll() {
    _botModel = null;
    _importedKnowledge = [];
  }
}