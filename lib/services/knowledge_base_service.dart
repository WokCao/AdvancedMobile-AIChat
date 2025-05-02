import 'package:ai_chat/utils/auth_interceptor.dart';
import 'package:dio/dio.dart';

import '../main.dart';

class KnowledgeBaseService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: "https://knowledge-api.dev.jarvis.cx"),
  );

  KnowledgeBaseService() {
    _dio.interceptors.add(AuthInterceptor(_dio, navigatorKey));
  }

  Future<Map<String, dynamic>> createKnowledge(
    String knowledgeName,
    String description,
  ) async {
    try {
      final response = await _dio.post(
        "/kb-core/v1/knowledge",
        data: {"knowledgeName": knowledgeName, "description": description},
        options: Options(headers: headers),
      );

      return {"success": true, "data": response.data};
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['error'] ??
          e.response?.data['message'] ??
          "Something went wrong";
      return {
        "success": false,
        "error": errorMessage,
        "code": e.response?.data['code'],
        "statusCode": e.response?.statusCode,
      };
    } catch (e) {
      return {"success": false, "error": "Unexpected error: $e"};
    }
  }

  Future<Map<String, dynamic>> updateKnowledge(
      String knowledgeName,
      String description,
      String knowledgeId
      ) async {
    try {
      final response = await _dio.patch(
        "/kb-core/v1/knowledge/$knowledgeId",
        data: {"knowledgeName": knowledgeName, "description": description},
        options: Options(headers: headers),
      );

      return {"success": true, "data": response.data};
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['error'] ??
              e.response?.data['message'] ??
              "Something went wrong";
      return {
        "success": false,
        "error": errorMessage,
        "code": e.response?.data['code'],
        "statusCode": e.response?.statusCode,
      };
    } catch (e) {
      return {"success": false, "error": "Unexpected error: $e"};
    }
  }

  Future<Map<String, dynamic>> getKnowledge({
    String query = '',
    required int offset,
    int limit = 7,
  }) async {
    try {
      final response = await _dio.get(
        "/kb-core/v1/knowledge?q=$query&offset=$offset&limit=$limit",
        options: Options(headers: headers),
      );

      return {"success": true, "data": response.data};
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['error'] ??
          e.response?.data['message'] ??
          "Something went wrong";
      return {
        "success": false,
        "error": errorMessage,
        "code": e.response?.data['code'],
        "statusCode": e.response?.statusCode,
      };
    } catch (e) {
      return {"success": false, "error": "Unexpected error: $e"};
    }
  }

  Future<bool> deleteKnowledge({required String id}) async {
    try {
      await _dio.delete(
        "/kb-core/v1/knowledge/$id",
        options: Options(headers: headers),
      );

      return true;
    } on DioException catch (e) {
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> getUnitsOfKnowledge({
    String query = '',
    required int offset,
    int limit = 7,
    required String id,
  }) async {
    try {
      final response = await _dio.get(
        "/kb-core/v1/knowledge/$id/units?q=$query&offset=$offset&limit=$limit",
        options: Options(headers: headers),
      );

      print(response.data);

      return {"success": true, "data": response.data};
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['error'] ??
          e.response?.data['message'] ??
          "Something went wrong";
      return {
        "success": false,
        "error": errorMessage,
        "code": e.response?.data['code'],
        "statusCode": e.response?.statusCode,
      };
    } catch (e) {
      return {"success": false, "error": "Unexpected error: $e"};
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
