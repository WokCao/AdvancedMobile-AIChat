import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../flavor_config.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final GlobalKey<NavigatorState> navigatorKey;

  AuthInterceptor(this._dio, this.navigatorKey);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refreshToken');

      if (refreshToken != null) {
        try {
          final refreshResponse = await _dio.post(
            'https://auth-api${FlavorConfig.baseUrl}.jarvis.cx/api/v1/auth/sessions/current/refresh',
            options: Options(
              headers: {
                'X-Stack-Access-Type': 'client',
                'X-Stack-Project-Id': 'a914f06b-5e46-4966-8693-80e4b9f4f409',
                'X-Stack-Publishable-Client-Key':
                    'pck_tqsy29b64a585km2g4wnpc57ypjprzzdch8xzpq0xhayr',
                'X-Stack-Refresh-Token': refreshToken,
              },
            ),
          );

          final newAccessToken = refreshResponse.data['access_token'];
          print('get new access token through refresh token');

          await prefs.setString('accessToken', newAccessToken);

          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $newAccessToken';
          final cloneReq = await _dio.fetch(opts);
          return handler.resolve(cloneReq);
        } catch (e) {
          print('invalid refresh token');
          await prefs.remove('accessToken');
          await prefs.remove('refreshToken');

          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            '/login',
                (route) => false,
          );
          return;
        }
      }

      await prefs.remove('accessToken');
      await prefs.remove('refreshToken');

      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
    }

    super.onError(err, handler);
  }
}
