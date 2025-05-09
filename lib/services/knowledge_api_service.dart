import 'dart:convert';
import 'package:ai_chat/models/bot_model.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../utils/auth_interceptor.dart';

class KnowledgeApiService {
  final Dio _dio;

  KnowledgeApiService({required String authToken})
      : _dio = Dio(
      BaseOptions(
        baseUrl: 'https://knowledge-api.dev.jarvis.cx',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      )
    ) {
    _dio.interceptors.add(AuthInterceptor(_dio, navigatorKey));
  }

  Future<bool> createBot({
    required String assistantName,
    String? instructions,
    String? description,
  }) async {
    try {
      final response = await _dio.post('/kb-core/v1/ai-assistant', data: {
        'assistantName': assistantName,
        if (instructions != null && instructions.isNotEmpty)
          'instructions': instructions,
        if (description != null && description.isNotEmpty)
          'description': description,
      });

      return response.statusCode == 201;
    } on DioException catch (e) {
      throw Exception('Create bot error: ${e.response?.data ?? e.message}');
    }
  }

  Future<List<BotModel>> getBots({String? search}) async {
    try {
      final response = await _dio.get(
        '/kb-core/v1/ai-assistant',
        queryParameters: {
          if (search != null && search.isNotEmpty) 'q': search,
          'limit': 50,
          'order': 'DESC',
          'order_field': 'createdAt',
        },
      );

      return (response.data['data'] as List)
          .map((item) => BotModel.fromJson(item))
          .toList();
    } on DioException catch (e) {
      throw Exception('Get bots failed: ${e.response?.data ?? e.message}');
    }
  }

  Future<Map<String, dynamic>> getImportedKnowledge({required String assistantId}) async {
    try {
      final response = await _dio.get(
        '/kb-core/v1/ai-assistant/$assistantId/knowledges'
      );

      print(response.data);
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Cannot get bot with id: $assistantId');
    }
  }

  Future<String> importKnowledgeToAssistant({required String assistantId, required String knowledgeId}) async {
    try {
      final response = await _dio.post(
          '/kb-core/v1/ai-assistant/$assistantId/knowledges/$knowledgeId'
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Cannot import knowledge to bot');
    }
  }

  Future<String> removeKnowledgeFromAssistant({required String assistantId, required String knowledgeId}) async {
    try {
      final response = await _dio.delete(
          '/kb-core/v1/ai-assistant/$assistantId/knowledges/$knowledgeId'
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Cannot remove knowledge from bot');
    }
  }

  Future<bool> updateBot({
    required String id,
    required String assistantName,
    String? instructions,
    String? description,
  }) async {
    try {
      final response = await _dio.patch(
        '/kb-core/v1/ai-assistant/$id',
        data: {
          'assistantName': assistantName,
          if (instructions != null && instructions.isNotEmpty)
            'instructions': instructions,
          if (description != null && description.isNotEmpty)
            'description': description,
        },
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception('Update bot failed: ${e.response?.data ?? e.message}');
    }
  }

  Future<bool> deleteBot(String id) async {
    try {
      final response = await _dio.delete('/kb-core/v1/ai-assistant/$id');
      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception('Delete bot failed: ${e.response?.data ?? e.message}');
    }
  }

  Future<void> askBotStream({
    required String assistantId,
    required String message,
    required String authToken,
    required void Function(Map<String, dynamic>) onData,
    void Function()? onDone,
    void Function(Object)? onError,
  }) async {
    final uri = Uri.parse('https://knowledge-api.dev.jarvis.cx/kb-core/v1/ai-assistant/$assistantId/ask');

    final request = http.Request('POST', uri)
      ..headers['Content-Type'] = 'application/json'
      ..headers['Authorization'] = 'Bearer $authToken'
      ..headers['Accept'] = 'text/event-stream'
      ..body = jsonEncode({'message': message});

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final stream = response.stream
            .transform(utf8.decoder)
            .transform(const LineSplitter());

        await for (final line in stream) {
          if (line.startsWith('data:')) {
            final jsonStr = line.replaceFirst('data:', '').trim();
            final data = json.decode(jsonStr);
            onData(data);
          }
        }

        onDone?.call();
      } else {
        throw Exception('Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      onError?.call(e);
    }
  }
}
