import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.dev.jarvis.cx', // base URL
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer eyJhbGciOiJFUzI1NiIsImtpZCI6IjNjbFlkbURkLVFrbSJ9.eyJzdWIiOiI0YWY2M2ZhYy01ODc3LTQ5NzctODcyNy02NTI3ZWZmYjljNzAiLCJicmFuY2hJZCI6Im1haW4iLCJpc3MiOiJodHRwczovL2FjY2Vzcy10b2tlbi5qd3Qtc2lnbmF0dXJlLnN0YWNrLWF1dGguY29tIiwiaWF0IjoxNzQ0MDE1Mzg4LCJhdWQiOiJhOTE0ZjA2Yi01ZTQ2LTQ5NjYtODY5My04MGU0YjlmNGY0MDkiLCJleHAiOjE3NDQwMTU5ODh9.GGq1ndg-sJwyWSH-iDa62qEVd0ND-4jManppe5YkkDSIIrXIFbr7vQZj8bLaAyorjcTkGIQ71aKsohpTZH-N1g', // Replace with your token
        'x-jarvis-guid': '361331f8-fc9b-4dfe-a3f7-6d9a1eb8b289', // Optional if required
      },
    ),
  );

  String? _conversationId;

  Future<String> sendMessage(String content, String modelId) async {
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
        return data['message'];
      } else {
        return 'Unexpected error: ${response.statusCode}';
      }
    } on DioException catch (e) {
      return 'Dio error: ${e.response?.data ?? e.message}';
    } catch (e) {
      return 'General error: $e';
    }
  }
}
