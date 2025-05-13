class BotModel {
  final String id;
  final String? description;
  final String? instructions;
  final String assistantName;
  final Map<String, dynamic> config;
  final String userId;
  final bool isDefault;
  final bool isFavorite;
  final List<String> permissions;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? deletedAt;

  BotModel({
    required this.id,
    required this.assistantName,
    required this.config,
    required this.userId,
    required this.isDefault,
    required this.isFavorite,
    required this.permissions,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.instructions,
    this.createdBy,
    this.updatedBy,
    this.deletedAt,
  });

  factory BotModel.empty({ required String id }) => BotModel(
    id: id,
    assistantName: '',
    config: const {},
    userId: '',
    isDefault: false,
    isFavorite: false,
    permissions: const [],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    description: null,
    instructions: null,
    createdBy: null,
    updatedBy: null,
    deletedAt: null,
  );

  factory BotModel.fromJson(Map<String, dynamic> json) {
    return BotModel(
      id: json['id'],
      assistantName: json['assistantName'],
      config: Map<String, dynamic>.from(json['config'] ?? {}),
      userId: json['userId'],
      isDefault: json['isDefault'] ?? false,
      isFavorite: json['isFavorite'] ?? false,
      permissions: List<String>.from(json['permissions'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      description: json['description'],
      instructions: json['instructions'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      deletedAt: json['deletedAt'] != null ? DateTime.tryParse(json['deletedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assistantName': assistantName,
      'config': config,
      'userId': userId,
      'isDefault': isDefault,
      'isFavorite': isFavorite,
      'permissions': permissions,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'description': description,
      'instructions': instructions,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }
}
