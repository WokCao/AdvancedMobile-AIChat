class MetaModel {
  final int limit;
  final int offset;
  final int total;
  final bool hasNext;

  MetaModel({
    required this.limit,
    required this.offset,
    required this.total,
    required this.hasNext,
  });

  factory MetaModel.fromJson(Map<String, dynamic> json) {
    return MetaModel(
      limit: json['limit'],
      offset: json['offset'],
      total: json['total'],
      hasNext: json['hasNext'],
    );
  }
}
