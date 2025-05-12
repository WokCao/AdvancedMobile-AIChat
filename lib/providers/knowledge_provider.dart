import 'package:ai_chat/models/knowledge_model.dart';
import 'package:flutter/material.dart';

import '../models/base_unit_model.dart';

class KnowledgeProvider extends ChangeNotifier {
  KnowledgeModel? _selectedKnowledge;
  final Set<BaseUnitModel> _data = {};
  bool _wasUpdated = false;

  KnowledgeModel? get selectedKnowledge => _selectedKnowledge;
  List<BaseUnitModel> get getUnitData => _data.toList();
  bool get wasUpdated => _wasUpdated;

  void setSelectedKnowledgeRow(
    KnowledgeModel? selectedKnowledge, {
    bool updated = false,
  }) {
    _selectedKnowledge = selectedKnowledge;
    _wasUpdated = updated;
    notifyListeners();
  }

  void updated() {
    _wasUpdated = true;
    notifyListeners();
  }

  void addUnitData(List<BaseUnitModel> unitData) {
    _data.addAll(unitData);
    notifyListeners();
  }

  void removeAUnit(String unitId) {
    _data.removeWhere((element) => element.id == unitId);
    notifyListeners();
  }

  void updateStatusOfAUnit(String unitId, bool status) {
    final updatedSet = <BaseUnitModel>{};

    bool found = false;
    for (final unit in _data) {
      if (unit.id == unitId) {
        updatedSet.add(unit.copyWith(status: status));
        found = true;
      } else {
        updatedSet.add(unit);
      }
    }

    if (!found) throw Exception("Unit not found");

    _data
      ..clear()
      ..addAll(updatedSet);
    notifyListeners();
  }

  void clearUnitData() {
    _data.clear();
    notifyListeners();
  }

  void clearUpdateFlag() {
    _wasUpdated = false;
  }
}
