import 'dart:io';

import 'package:ai_chat/utils/auth_interceptor.dart';
import 'package:ai_chat/utils/knowledge_exception.dart';
import 'package:dio/dio.dart';

import '../flavor_config.dart';
import '../main.dart';

class DataSourceService {
  final Dio _dioKnowledgeApi = Dio(
    BaseOptions(baseUrl: "https://knowledge-api${FlavorConfig.baseUrl}.jarvis.cx"),
  );

  DataSourceService() {
    _dioKnowledgeApi.interceptors.add(AuthInterceptor(_dioKnowledgeApi, navigatorKey));
  }

  Future<Map<String, dynamic>> createUnitFileType({
    required String knowledgeId,
    required File file,
  }) async {
    try {
      String mimeType = _getMimeType(file.path);
      final formData = FormData.fromMap({
        "files": [await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
          contentType: DioMediaType.parse(mimeType),
        )],
      });

      final uploadResponse = await _dioKnowledgeApi.post(
        "/kb-core/v1/knowledge/files",
        data: formData,
        options: Options(headers: headers),
      );

      final String fileId = uploadResponse.data["files"][0]["id"];
      final response = await _dioKnowledgeApi.post(
        "/kb-core/v1/knowledge/$knowledgeId/datasources",
        data: {
          "datasources": [
            {
              "type": "local_file",
              "name": file.path.split('/').last,
              "credentials": {
                "file": fileId
              }
            }
          ]
        },
        options: Options(headers: { ...headers, 'Content-Type': 'application/json' } ),
      );

      return response.data;
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ?? "Failed to create unit (File) - Path: ${file.path.split("/").last}";
      throw KnowledgeException(errorMessage, statusCode: e.response?.statusCode);
    }
  }

  Future<Map<String, dynamic>> createUnitWebURL({
    required String knowledgeId,
    required String unitName,
    required String webUrl,
  }) async {
    try {
      final response = await _dioKnowledgeApi.post(
        "/kb-core/v1/knowledge/$knowledgeId/datasources",
        data: {
          "unitName": unitName,
          "webUrl": webUrl
        },
        options: Options(headers: { ...headers, 'Content-Type': 'application/json' } ),
      );

      return response.data;
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ?? "Failed to create unit (Website) - Url: $webUrl";
      throw KnowledgeException(errorMessage, statusCode: e.response?.statusCode);
    }
  }

  Future<Map<String, dynamic>> createUnitSlack({
    required String knowledgeId,
    required String unitName,
    required String slackBotToken,
  }) async {
    try {
      final response = await _dioKnowledgeApi.post(
        "/kb-core/v1/knowledge/$knowledgeId/datasources",
        data: {
          "datasources": [
            {
              "type": "slack",
              "name": unitName,
              "credentials": {
                "token": slackBotToken
              }
            }
          ]
        },
        options: Options(headers: { ...headers, 'Content-Type': 'application/json' } ),
      );

      return response.data;
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ?? "Failed to create unit (Slack)";
      throw KnowledgeException(errorMessage, statusCode: e.response?.statusCode);
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
      final response = await _dioKnowledgeApi.post(
        "/kb-core/v1/knowledge/$knowledgeId/datasources",
        data: {
          "datasources": [
            {
              "type": "confluence",
              "name": unitName,
              "credentials": {
                "token": confluenceAccessToken,
                "url": wikiPageUrl,
                "username": confluenceUsername
              }
            }
          ]
        },
        options: Options(headers: { ...headers, 'Content-Type': 'application/json' } ),
      );

      return response.data;
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ?? "Failed to create unit (Confluence)";
      throw KnowledgeException(errorMessage, statusCode: e.response?.statusCode);
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
      case 'c':
        return 'text/x-c';
      case 'cpp':
        return 'text/x-c++';
      case 'csv':
        return 'text/csv';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'epub':
        return 'application/epub+zip';
      case 'gif':
        return 'image/gif';
      case 'htm':
      case 'html':
        return 'text/html';
      case 'java':
        return 'text/x-java-source';
      case 'jpeg':
      case 'jpg':
        return 'image/jpeg';
      case 'js':
        return 'application/javascript';
      case 'json':
        return 'application/json';
      case 'log':
      case 'txt':
        return 'text/plain';
      case 'md':
        return 'text/markdown';
      case 'odp':
        return 'application/vnd.oasis.opendocument.presentation';
      case 'ods':
        return 'application/vnd.oasis.opendocument.spreadsheet';
      case 'odt':
        return 'application/vnd.oasis.opendocument.text';
      case 'pdf':
        return 'application/pdf';
      case 'php':
        return 'application/x-httpd-php';
      case 'png':
        return 'image/png';
      case 'ppt':
        return 'application/vnd.ms-powerpoint';
      case 'pptx':
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      case 'py':
        return 'text/x-python';
      case 'rb':
        return 'text/x-ruby';
      case 'rtf':
        return 'application/rtf';
      case 'svg':
        return 'image/svg+xml';
      case 'tex':
        return 'application/x-tex';
      case 'tif':
      case 'tiff':
        return 'image/tiff';
      case 'tsv':
        return 'text/tab-separated-values';
      case 'xls':
        return 'application/vnd.ms-excel';
      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case 'xml':
        return 'application/xml';
      case 'yaml':
      case 'yml':
        return 'application/x-yaml';
      default:
        return 'application/octet-stream';
    }
  }
}
