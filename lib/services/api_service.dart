import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../main.dart';
import '../utils/auth_interceptor.dart';

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
  ) { _dio.interceptors.add(AuthInterceptor(_dio, navigatorKey));}

  String? _conversationId;

  Future<Map<String, dynamic>> sendMessage({
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
        return {
          'message': data['message'],
          'remainingUsage': response.data['remainingUsage'] ?? 0,
        };
      } else {
        throw Exception("Unexpected status: ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw Exception("Dio error: ${e.response?.data ?? e.message}");
    } catch (e) {
      throw Exception("General error: $e");
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

  Future<int?> getAvailableTokens() async {
    try {
      final response = await _dio.get('/api/v1/tokens/usage');

      if (response.statusCode == 200) {
        return response.data['availableTokens'];
      } else {
        throw Exception('Failed to fetch token usage');
      }
    } on DioException catch (e) {
      throw Exception("Dio error: ${e.response?.data ?? e.message}");
    }
  }

  Future<Map<String, dynamic>> getPublicPrompts({
    int offset = 0,
    int limit = 20,
    String query = '',
    String category = 'All',
    bool isFavorite = false,
  }) async {
    try {
      final response = await _dio.get(
        '/api/v1/prompts',
        queryParameters: {
          'isPublic': true,
          'offset': offset,
          'limit': limit,
          if (query.isNotEmpty) 'query': query,
          if (category != 'All') 'category': category.toLowerCase(),
          if (isFavorite) 'isFavorite': true,
        },
      );

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception("Unexpected status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching prompts: $e");
    }
  }

  Future<Map<String, dynamic>> getPrivatePrompts({
    int offset = 0,
    int limit = 20,
    String query = '',
  }) async {
    try {
      final response = await _dio.get(
        '/api/v1/prompts',
        queryParameters: {
          'isPublic': false,
          'offset': offset,
          'limit': limit,
          if (query.isNotEmpty) 'query': query,
        },
      );

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception("Unexpected status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching prompts: $e");
    }
  }

  Future<bool> togglePromptFavorite(String id, {required bool isCurrentlyFavorited}) async {
    try {
      final path = '/api/v1/prompts/$id/favorite';
      final response = isCurrentlyFavorited
          ? await _dio.delete(path)
          : await _dio.post(path);
      final successCode = isCurrentlyFavorited ? 200 : 201;

      if (response.statusCode == successCode) {
        return true;
      } else {
        throw Exception("Failed to toggle favorite prompt");
      }
    } on DioException catch (e) {
      throw Exception("Favorite toggle failed: ${e.message}");
    }
  }
}
