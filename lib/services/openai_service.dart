import 'package:dio/dio.dart';

Future<Map<String, dynamic>> createOpenAiThread() async {
  try {
    final response = await Dio().post('https://royalmike.com/api/openai/create-thread');
    return response.data;
  } on DioException catch (e) {
    throw Exception('Failed to create OpenAI thread: ${e.response?.data ?? e.message}');
  }
}
