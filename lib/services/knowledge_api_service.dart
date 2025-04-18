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
}
