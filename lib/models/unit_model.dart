class UnitModel {
  final String id;
  final String name;
  final String type;
  final int size;
  final bool status;
  final String userId;
  final String knowledgeId;
  final List<String> openAiFileIds;
  final Metadata metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? createdBy;
  final String? updatedBy;

  UnitModel({
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

  factory UnitModel.fromJson(Map<String, dynamic> json) {
    return UnitModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      size: json['size'],
      status: json['status'],
      userId: json['userId'],
      knowledgeId: json['knowledgeId'],
      openAiFileIds: List<String>.from(json['openAiFileIds']),
      metadata: Metadata.fromJson(json['metadata']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'size': size,
      'status': status,
      'userId': userId,
      'knowledgeId': knowledgeId,
      'openAiFileIds': openAiFileIds,
      'metadata': metadata.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'createdBy': createdBy,
      'updatedBy': updatedBy,
    };
  }
}

class Metadata {
  final String name;
  final String mimetype;

  Metadata({
    required this.name,
    required this.mimetype,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      name: json['name'],
      mimetype: json['mimetype'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mimetype': mimetype,
    };
  }
}
