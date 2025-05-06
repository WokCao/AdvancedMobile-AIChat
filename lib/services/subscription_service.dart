import 'package:ai_chat/utils/auth_interceptor.dart';
import 'package:ai_chat/utils/knowledge_exception.dart';
import 'package:dio/dio.dart';

import '../main.dart';

class SubscriptionService {
  final Dio _dioSubscription = Dio(
    BaseOptions(baseUrl: "https://api.dev.jarvis.cx"),
  );

  SubscriptionService() {
    _dioSubscription.interceptors.add(AuthInterceptor(_dioSubscription, navigatorKey));
  }

  Future<Map<String, dynamic>> getSubscription() async {
    try {
      final response = await _dioSubscription.get(
        "/api/v1/subscriptions/me",
        options: Options(headers: headers),
      );

      return response.data;
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ?? "Failed to get subscription";
      throw KnowledgeException(errorMessage, statusCode: e.response?.statusCode);
    }
  }

  Future<Map<String, dynamic>> getToken() async {
    try {
      final response = await _dioSubscription.get(
        "/api/v1/tokens/usage",
        options: Options(headers: headers),
      );

      return response.data;
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ?? "Failed to get subscription";
      throw KnowledgeException(errorMessage, statusCode: e.response?.statusCode);
    }
  }

  static const headers = {
    'X-Stack-Access-Type': 'client',
    'X-Stack-Project-Id': 'a914f06b-5e46-4966-8693-80e4b9f4f409',
    'X-Stack-Publishable-Client-Key':
    'pck_tqsy29b64a585km2g4wnpc57ypjprzzdch8xzpq0xhayr',
    'Content-Type': 'application/json',
  };
}
