import 'package:ai_chat/utils/auth_interceptor.dart';
import 'package:ai_chat/utils/knowledge_exception.dart';
import 'package:dio/dio.dart';

import '../flavor_config.dart';
import '../main.dart';

class BotIntegrationService {
  final Dio _dioKnowledgeApi = Dio(
    BaseOptions(baseUrl: "https://knowledge-api${FlavorConfig.baseUrl}.jarvis.cx"),
  );

  BotIntegrationService() {
    _dioKnowledgeApi.interceptors.add(AuthInterceptor(_dioKnowledgeApi, navigatorKey));
  }

  Future<dynamic> messengerVerify({required String botToken, required String pageId, required String appSecret}) async {
    try {
      final response = await _dioKnowledgeApi.post(
        "/kb-core/v1/bot-integration/messenger/validation",
        data: {
          "botToken": botToken,
          "pageId": pageId,
          "appSecret": appSecret
        },
        options: Options(headers: headers),
      );

      return response.data;
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ?? "Failed to verify messenger data";
      throw KnowledgeException(errorMessage, statusCode: e.response?.statusCode);
    }
  }

  Future<dynamic> messengerPublish({required String assistantId, required String botToken, required String pageId, required String appSecret}) async {
    try {
      await messengerVerify(botToken: botToken, pageId: pageId, appSecret: appSecret);
      final response = await _dioKnowledgeApi.post(
        "/kb-core/v1/bot-integration/messenger/publish/$assistantId",
        data: {
          "botToken": botToken,
          "pageId": pageId,
          "appSecret": appSecret
        },
        options: Options(headers: headers),
      );

      return response.data;
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ?? "Failed to publish messenger bot";
      throw KnowledgeException(errorMessage, statusCode: e.response?.statusCode);
    }
  }

  Future<Map<String, dynamic>> slackVerify({required String botToken, required String clientId, required String clientSecret, required String signingSecret}) async {
    try {
      final response = await _dioKnowledgeApi.post(
        "/kb-core/v1/bot-integration/slack/validation",
        data: {
          "botToken": botToken,
          "clientId": clientId,
          "clientSecret": clientSecret,
          "signingSecret": signingSecret
        },
        options: Options(headers: headers),
      );

      return response.data;
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ?? "Failed to verify slack data";
      throw KnowledgeException(errorMessage, statusCode: e.response?.statusCode);
    }
  }

  Future<dynamic> slackPublish({required String assistantId, required String botToken, required String clientId, required String clientSecret, required String signingSecret}) async {
    try {
      await slackVerify(botToken: botToken, clientId: clientId, clientSecret: clientSecret, signingSecret: signingSecret);
      final response = await _dioKnowledgeApi.patch(
        "/kb-core/v1/bot-integration/slack/publish/$assistantId",
        data: {
          "botToken": botToken,
          "clientId": clientId,
          "clientSecret": clientSecret,
          "signingSecret": signingSecret
        },
        options: Options(headers: headers),
      );

      return response.data;
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ?? "Failed to publish slack bot";
      throw KnowledgeException(errorMessage, statusCode: e.response?.statusCode);
    }
  }

  Future<Map<String, dynamic>> telegramVerify({required String botToken}) async {
    try {
      final response = await _dioKnowledgeApi.post(
        "/kb-core/v1/bot-integration/telegram/validation",
        data: {
          "botToken": botToken
        },
        options: Options(headers: headers),
      );

      return response.data;
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ?? "Failed to verify telegram data";
      throw KnowledgeException(errorMessage, statusCode: e.response?.statusCode);
    }
  }

  Future<dynamic> telegramPublish({required String assistantId, required String botToken}) async {
    try {
      await telegramVerify(botToken: botToken);
      final response = await _dioKnowledgeApi.patch(
        "/kb-core/v1/bot-integration/telegram/publish/$assistantId",
        data: {
          "botToken": botToken
        },
        options: Options(headers: headers),
      );

      return response.data;
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ?? "Failed to publish telegram bot";
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
