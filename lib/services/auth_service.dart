import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://auth-api.dev.jarvis.cx", headers: headers));

  static const headers = {
    'X-Stack-Access-Type': 'client',
    'X-Stack-Project-Id': 'a914f06b-5e46-4966-8693-80e4b9f4f409',
    'X-Stack-Publishable-Client-Key':
        'pck_tqsy29b64a585km2g4wnpc57ypjprzzdch8xzpq0xhayr',
    'Content-Type': 'application/json',
  };

  Future<Map<String, dynamic>> signUp(String email, String password) async {
    try {
      final response = await _dio.post(
        "/api/v1/auth/password/sign-up",
        data: {
          "email": email,
          "password": password,
          "verification_callback_url":
          "https://auth.dev.jarvis.cx/handler/email-verification?after_auth_return_to=%2Fauth%2Fsignin%3Fclient_id%3Djarvis_chat%26redirect%3Dhttps%253A%252F%252Fchat.dev.jarvis.cx%252Fauth%252Foauth%252Fsuccess"
        },
      );
      return {
        "success": true,
        "data": response.data,
      };
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ??
          e.response?.data['message'] ??
          "Something went wrong";
      return {
        "success": false,
        "error": errorMessage,
        "code": e.response?.data['code'],
        "statusCode": e.response?.statusCode,
      };
    } catch (e) {
      return {
        "success": false,
        "error": "Unexpected error: $e",
      };
    }
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      final response = await _dio.post(
        "/api/v1/auth/password/sign-in",
        data: {
          "email": email,
          "password": password,
        },
      );
      return {
        "success": true,
        "data": response.data,
      };
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ??
          e.response?.data['message'] ??
          "Something went wrong";
      return {
        "success": false,
        "error": errorMessage,
        "code": e.response?.data['code'],
        "statusCode": e.response?.statusCode,
      };
    } catch (e) {
      return {
        "success": false,
        "error": "Unexpected error: $e",
      };
    }
  }

  Future<Map<String, dynamic>> logout(String token, String refreshToken) async {
    try {
      await _dio.delete(
        "/api/v1/auth/sessions/current",
        data: {},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'X-Stack-Refresh-Token': refreshToken,
          }
        )
      );

      return {
        "success": true
      };

    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ??
          e.response?.data['message'] ??
          "Something went wrong";
      return {
        "success": false,
        "error": errorMessage,
        "code": e.response?.data['code'],
        "statusCode": e.response?.statusCode,
      };
    } catch (e) {
      return {
        "success": false,
        "error": "Unexpected error: $e",
      };
    }
  }
}
