import 'package:ai_chat/models/prompt_model.dart';
import 'package:flutter/material.dart';

class PromptProvider extends ChangeNotifier {
  PromptModel? _promptModel;

  PromptModel? get promptModel => _promptModel;

  void setSelectedPromptModel({ required PromptModel? promptModel }) {
    _promptModel = promptModel;
    notifyListeners();
  }
}