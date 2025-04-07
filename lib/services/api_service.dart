import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService({required String authToken})
      : _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.dev.jarvis.cx',
      headers: {
        'Content-Type': 'application/json',
        if (authToken.isNotEmpty) 'Authorization': 'Bearer $authToken',
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
}
