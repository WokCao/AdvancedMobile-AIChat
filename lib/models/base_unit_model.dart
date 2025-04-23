abstract class BaseUnitModel {
  String get id;
  String get name;
  String get type;
  int get size;
  bool get status;
  String get userId;
  String get knowledgeId;
  List<String> get openAiFileIds;
  DateTime get createdAt;
  DateTime get updatedAt;
  DateTime? get deletedAt;
  String? get createdBy;
  String? get updatedBy;

  dynamic get metadata;
  String get displayName => '';
}
