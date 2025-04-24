import 'dart:io';

import 'package:ai_chat/utils/auth_interceptor.dart';
import 'package:dio/dio.dart';

import '../main.dart';

class DataSourceService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: "https://knowledge-api.dev.jarvis.cx"),
  );

  DataSourceService() {
    _dio.interceptors.add(AuthInterceptor(_dio, navigatorKey));
  }

  Future<Map<String, dynamic>> createUnitFileType({
    required String knowledgeId,
    required File file,
  }) async {
    try {
      String mimeType = _getMimeType(file.path);
      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
          contentType: DioMediaType.parse(mimeType),
        ),
      });

      final response = await _dio.post(
        "/kb-core/v1/knowledge/$knowledgeId/local-file",
        data: formData,
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

  Future<Map<String, dynamic>> createUnitWebURL({
    required String knowledgeId,
    required String unitName,
    required String webUrl,
  }) async {
    try {
      final response = await _dio.post(
        "/kb-core/v1/knowledge/$knowledgeId/web",
        data: {
          "unitName": unitName,
          "webUrl": webUrl
        },
        options: Options(headers: { ...headers, 'Content-Type': 'application/json' } ),
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

  Future<Map<String, dynamic>> createUnitSlack({
    required String knowledgeId,
    required String unitName,
    required String slackWorkspace,
    required String slackBotToken,
  }) async {
    try {
      final response = await _dio.post(
        "/kb-core/v1/knowledge/$knowledgeId/slack",
        data: {
          "unitName": unitName,
          "slackWorkspace": slackWorkspace,
          "slackBotToken": slackBotToken
        },
        options: Options(headers: { ...headers, 'Content-Type': 'application/json' } ),
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

  Future<Map<String, dynamic>> createUnitConfluence({
    required String knowledgeId,
    required String unitName,
    required String wikiPageUrl,
    required String confluenceUsername,
    required String confluenceAccessToken,
  }) async {
    try {
      final response = await _dio.post(
        "/kb-core/v1/knowledge/$knowledgeId/confluence",
        data: {
          "unitName": unitName,
          "wikiPageUrl": wikiPageUrl,
          "confluenceUsername": confluenceUsername,
          "confluenceAccessToken": confluenceAccessToken
        },
        options: Options(headers: { ...headers, 'Content-Type': 'application/json' } ),
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

  static const headers = {
    'X-Stack-Access-Type': 'client',
    'X-Stack-Project-Id': 'a914f06b-5e46-4966-8693-80e4b9f4f409',
    'X-Stack-Publishable-Client-Key':
        'pck_tqsy29b64a585km2g4wnpc57ypjprzzdch8xzpq0xhayr',
  };

  String _getMimeType(String filePath) {
    String extension = filePath.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return 'application/pdf';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'txt':
        return 'text/plain';
      case 'json':
        return 'application/json';
      case 'html':
        return 'text/html';
      case 'java':
        return 'text/x-java';
      case 'cpp':
        return 'text/x-c++';
      case 'py':
        return 'text/x-python';
      case 'md':
        return 'text/markdown';
      case 'pptx':
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      default:
        return 'application/octet-stream';
    }
  }
}
