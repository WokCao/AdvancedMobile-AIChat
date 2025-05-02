import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../utils/auth_exception.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;
  String? _error;
  String? _email;

  UserModel? get user => _user;
  String? get error => _error;
  String? get email => _email;

  Future<bool> signUp({required String email, required String password}) async {
    try {
      final data = await _authService.signUp(email, password);
      _user = UserModel(
        userId: data['user_id'],
        accessToken: data['access_token'],
        refreshToken: data['refresh_token'],
      );
      _email = email;
      _clearError();
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    try {
      final data = await _authService.signIn(email, password);
      _user = UserModel(
        userId: data['user_id'],
        accessToken: data['access_token'],
        refreshToken: data['refresh_token'],
      );
      _email = email;
      _clearError();
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    }
  }

  Future<bool> isLoggedIn({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      final data = await _authService.isLoggedIn();
      _user = UserModel(
        userId: data['id'],
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
      _email = data['email'];
      _clearError();
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      _user = null;
      return false;
    }
  }

  Future<bool> logout({required String refreshToken}) async {
    try {
      await _authService.logout(refreshToken);
      _user = null;
      _email = null;
      _clearError();
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    }
  }

  void _setError(String? message) {
    _error = message ?? "An unexpected error occurred";
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
