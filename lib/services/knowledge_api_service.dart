import 'package:dio/dio.dart';
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

  Future<List<Map<String, dynamic>>> getBots({String? search}) async {
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

      return List<Map<String, dynamic>>.from(response.data['data']);
    } on DioException catch (e) {
      throw Exception('Get bots failed: ${e.response?.data ?? e.message}');
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
}
