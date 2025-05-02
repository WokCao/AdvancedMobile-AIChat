import 'base_unit_model.dart';
import 'metadata_classes.dart';

class FileUnitModel implements BaseUnitModel {
  @override final String id, name, type, userId, knowledgeId;
  @override final int size;
  @override final bool status;
  @override final List<String> openAiFileIds;
  @override final DateTime createdAt, updatedAt;
  @override final DateTime? deletedAt;
  @override final String? createdBy, updatedBy;
  @override final FileMetadata metadata;

  FileUnitModel({
    required this.id,
    required this.name,
    required this.type,
    required this.size,
    required this.status,
    required this.userId,
    required this.knowledgeId,
    required this.openAiFileIds,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.createdBy,
    this.updatedBy,
  });

  factory FileUnitModel.fromJson(Map<String, dynamic> json) => FileUnitModel(
    id: json['id'],
    name: json['name'],
    type: json['type'],
    size: json['size'],
    status: json['status'],
    userId: json['userId'],
    knowledgeId: json['knowledgeId'],
    openAiFileIds: List<String>.from(json['openAiFileIds']),
    metadata: FileMetadata.fromJson(json['metadata']),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    createdBy: json['createdBy'],
    updatedBy: json['updatedBy'],
  );

  @override
  String get displayName => metadata.name;
}
