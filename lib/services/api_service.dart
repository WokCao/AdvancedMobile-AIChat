import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService({required String authToken})
      : _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.dev.jarvis.cx',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
        'x-jarvis-guid': '361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b',
      },
    ),
  );

  String? _conversationId;

  Future<String> sendMessage({
    required String content,
    required String modelId
  }) async {
    try {
      final response = await _dio.post(
        '/api/v1/ai-chat/messages',
        data: {
          "content": content,
          "files": [],
          "metadata": {
            "conversation": {
              "messages": [],
            },
          },
          "assistant": {
            "id": modelId, // e.g. "gpt-4o-mini"
            "model": "dify", // required
          }
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        _conversationId = data['conversationId'];
        return data['message'];
      } else {
        return 'Unexpected error: ${response.statusCode}';
      }
    } on DioException catch (e) {
      return 'Dio error: ${e.response?.data ?? e.message}';
    } catch (e) {
      return 'General error: $e';
    }
  }

  Future<List<Map<String, dynamic>>> getConversations({
    required String modelId,
    String? cursor,
    int limit = 100,
  }) async {
    try {
      final response = await _dio.get(
        '/api/v1/ai-chat/conversations',
        queryParameters: {
          'cursor': cursor,
          'limit': limit,
          'assistantId': modelId,
          'assistantModel': 'dify',
        },
      );

      if (response.statusCode == 200) {
        final items = List<Map<String, dynamic>>.from(response.data['items'] ?? []);
        return items;
      } else {
        throw Exception("Unexpected status: ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw Exception("Dio error: ${e.response?.data ?? e.message}");
    }
  }
}
