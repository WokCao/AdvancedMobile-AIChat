class KnowledgeException implements Exception {
  final String message;
  final int? statusCode;

  KnowledgeException(this.message, {this.statusCode});

  @override
  String toString() => 'KnowledgeException: $message (status: $statusCode)';
}