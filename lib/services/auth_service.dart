import 'package:ai_chat/utils/auth_interceptor.dart';
import 'package:dio/dio.dart';

import '../main.dart';
import '../utils/auth_exception.dart';

class AuthService {
  final Dio _dioAuthApi = Dio(BaseOptions(baseUrl: "https://auth-api.dev.jarvis.cx"));
  final Dio _dioApi = Dio(BaseOptions(baseUrl: "https://api.dev.jarvis.cx"));

  AuthService() {
    _dioAuthApi.interceptors.add(AuthInterceptor(_dioAuthApi, navigatorKey));
    _dioApi.interceptors.add(AuthInterceptor(_dioApi, navigatorKey));
  }

  Future<Map<String, dynamic>> signUp(String email, String password) async {
    try {
      final response = await _dioAuthApi.post(
        "/api/v1/auth/password/sign-up",
        data: {
          "email": email,
          "password": password,
          "verification_callback_url":
              "https://auth.dev.jarvis.cx/handler/email-verification?after_auth_return_to=%2Fauth%2Fsignin%3Fclient_id%3Djarvis_chat%26redirect%3Dhttps%253A%252F%252Fchat.dev.jarvis.cx%252Fauth%252Foauth%252Fsuccess",
        },
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ?? "Sign-up failed";
      throw AuthException(errorMessage, statusCode: e.response?.statusCode);
    }
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      final response = await _dioAuthApi.post(
        "/api/v1/auth/password/sign-in",
        data: {"email": email, "password": password},
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ?? "Sign-in failed";
      throw AuthException(errorMessage, statusCode: e.response?.statusCode);
    }
  }

  Future<Map<String, dynamic>> isLoggedIn() async {
    try {
      final response = await _dioApi.get(
        "/api/v1/auth/me",
        options: Options(
          headers: {
            'x-jarvis-guid': '361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b',
          },
        ),
      );
      final data = response.data;
      return {'isLoggedIn': true, 'id': data['id'], 'email': data['email'], 'username': data['username']};
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ?? "Invalid access token";
      throw AuthException(errorMessage, statusCode: e.response?.statusCode);
    }
  }

  Future<void> logout(String refreshToken) async {
    try {
      await _dioAuthApi.delete(
        "/api/v1/auth/sessions/current",
        options: Options(
          headers: {
            ...headers,
            'X-Stack-Refresh-Token': refreshToken,
          },
        ),
      );
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ?? "Log-out failed";
      throw AuthException(errorMessage, statusCode: e.response?.statusCode);
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
