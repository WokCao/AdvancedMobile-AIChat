import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;
  String? _error;

  UserModel? get user => _user;
  String? get error => _error;

  Future<bool> signUp(String email, String password) async {
    final result = await _authService.signUp(email, password);
    if (result['success']) {
      final data = result['data'];
      _user = UserModel(
        userId: data['user_id'],
        accessToken: data['access_token'],
        refreshToken: data['refresh_token'],
      );
      _error = null;
      notifyListeners();
      return true;
    } else {
      _error = result['error'];
      notifyListeners();
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    final result = await _authService.signIn(email, password);
    if (result['success']) {
      final data = result['data'];
      _user = UserModel(
        userId: data['user_id'],
        accessToken: data['access_token'],
        refreshToken: data['refresh_token'],
      );

      _error = null;
      notifyListeners();
      return true;
    } else {
      _error = result['error'];
      notifyListeners();
      return false;
    }
  }

  Future<bool> isLoggedIn(String token, String refreshToken) async {
    final result = await _authService.isLoggedIn();
    if (result['isLoggedIn']) {
      _user = UserModel(userId: result['id'], accessToken: token, refreshToken: refreshToken);
      _error = null;
      notifyListeners();
      return true;
    } else {
      _error = 'Invalid token';
      _user = null;
      notifyListeners();
      return false;
    }
  }

  Future<bool> logout(String refreshToken) async {
    final result = await _authService.logout(refreshToken);
    if (result['success']) {
      _user = null;
      _error = null;
      notifyListeners();
      return true;
    } else {
      _error = result['error'];
      notifyListeners();
      return false;
    }
  }
}
