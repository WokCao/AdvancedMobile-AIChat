class KnowledgeMetaModel {
  final int limit;
  final int offset;
  final int total;
  final bool hasNext;

  KnowledgeMetaModel({
    required this.limit,
    required this.offset,
    required this.total,
    required this.hasNext,
  });

  factory KnowledgeMetaModel.fromJson(Map<String, dynamic> json) {
    return KnowledgeMetaModel(
      limit: json['limit'],
      offset: json['offset'],
      total: json['total'],
      hasNext: json['hasNext'],
    );
  }
}
