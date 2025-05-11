import 'package:ai_chat/utils/auth_interceptor.dart';
import 'package:ai_chat/utils/knowledge_exception.dart';
import 'package:dio/dio.dart';

import '../flavor_config.dart';
import '../main.dart';

class KnowledgeBaseService {
  final Dio _dioKnowledgeApi = Dio(
    BaseOptions(baseUrl: "https://knowledge-api${FlavorConfig.baseUrl}.jarvis.cx"),
  );

  KnowledgeBaseService() {
    _dioKnowledgeApi.interceptors.add(AuthInterceptor(_dioKnowledgeApi, navigatorKey));
  }

  Future<Map<String, dynamic>> createKnowledge({required String knowledgeName, required String description}) async {
    try {
      final response = await _dioKnowledgeApi.post(
        "/kb-core/v1/knowledge",
        data: {"knowledgeName": knowledgeName, "description": description},
        options: Options(headers: headers),
      );

      return response.data;
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ?? "Failed to create new knowledge";
      throw KnowledgeException(errorMessage, statusCode: e.response?.statusCode);
    }
  }

  Future<Map<String, dynamic>> updateKnowledge({required String knowledgeName, required String description, required String knowledgeId}) async {
    try {
      final response = await _dioKnowledgeApi.patch(
        "/kb-core/v1/knowledge/$knowledgeId",
        data: {"knowledgeName": knowledgeName, "description": description},
        options: Options(headers: headers),
      );

      return response.data;
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ?? "Failed to update existing knowledge";
      throw KnowledgeException(errorMessage, statusCode: e.response?.statusCode);
    }
  }

  Future<Map<String, dynamic>> getKnowledge({String query = '', required int offset, int limit = 7,}) async {
    try {
      final response = await _dioKnowledgeApi.get(
        "/kb-core/v1/knowledge?q=$query&offset=$offset&limit=$limit",
        options: Options(headers: headers),
      );

      return response.data;
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ?? "Failed to load knowledge";
      throw KnowledgeException(errorMessage, statusCode: e.response?.statusCode);
    }
  }

  Future<void> deleteKnowledge({required String id}) async {
    try {
      await _dioKnowledgeApi.delete(
        "/kb-core/v1/knowledge/$id",
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ?? "Failed to delete knowledge";
      throw KnowledgeException(errorMessage, statusCode: e.response?.statusCode);
    }
  }

  Future<Map<String, dynamic>> getUnitsOfKnowledge({String query = '', required int offset, int limit = 7, required String id,}) async {
    try {
      final response = await _dioKnowledgeApi.get(
        "/kb-core/v1/knowledge/$id/datasources?q=$query&offset=$offset&limit=$limit",
        options: Options(headers: headers),
      );

      return response.data;
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ?? "Failed to load knowledge's units";
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
