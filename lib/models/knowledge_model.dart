class KnowledgeModel {
  final String id;
  final String knowledgeName;
  final String description;
  final String? userId;
  final int numUnits;
  final int totalSize;
  final DateTime createdAt;
  final DateTime updatedAt;

  KnowledgeModel({
    required this.id,
    required this.knowledgeName,
    required this.description,
    required this.userId,
    required this.numUnits,
    required this.totalSize,
    required this.createdAt,
    required this.updatedAt,
  });

  factory KnowledgeModel.fromJson(Map<String, dynamic> json) {
    return KnowledgeModel(
      id: json['id'],
      knowledgeName: json['knowledgeName'],
      description: json['description'],
      userId: json['userId'],
      numUnits: json['numUnits'] ?? 0,
      totalSize: json['totalSize'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'knowledgeName': knowledgeName,
      'description': description,
      'userId': userId,
      'numUnits': numUnits,
      'totalSize': totalSize,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'KnowledgeModel('
        'id: $id, '
        'knowledgeName: $knowledgeName, '
        'description: $description, '
        'userId: $userId, '
        'numUnits: $numUnits, '
        'totalSize: $totalSize, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt'
        ')';
  }
}
