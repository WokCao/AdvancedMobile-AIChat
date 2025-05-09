class BaseUnitModel {
  final String id;
  final String name;
  final String type;
  final int size;
  final bool status;
  final String userId;
  final String knowledgeId;

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? createdBy;
  final String? updatedBy;

  dynamic metadata;
  String get displayName => name;

  BaseUnitModel({
    required this.id,
    required this.name,
    required this.type,
    required this.size,
    required this.status,
    required this.userId,
    required this.knowledgeId,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.createdBy,
    this.updatedBy,
  });

  factory BaseUnitModel.fromJson(Map<String, dynamic> json) => BaseUnitModel(
    id: json['id'],
    name: json['name'],
    type: json['type'],
    size: json['size'],
    status: json['status'],
    userId: json['userId'],
    knowledgeId: json['knowledgeId'],
    metadata: json['metadata'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    createdBy: json['createdBy'],
    updatedBy: json['updatedBy'],
  );
}
