import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulação de login
      await Future.delayed(const Duration(seconds: 1));
      
      if (email == 'admin@example.com' && password == '123456') {
        _currentUser = UserModel(
          id: '1',
          name: 'Admin',
          email: 'admin@example.com',
          phone: '(11) 99999-9999',
          password: '123456',
          role: 'admin',
        );
        return true;
      } else {
        _error = 'Email ou senha incorretos';
        return false;
      }
    } catch (e) {
      _error = 'Erro ao fazer login: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }

  bool validateCurrentPassword(String password) {
    return _currentUser?.password == password;
  }

  Future<void> updateUser(UserModel user) async {
    if (_currentUser == null) return;

    _currentUser = UserModel(
      id: _currentUser!.id,
      name: user.name,
      email: _currentUser!.email,
      phone: user.phone,
      password: user.password,
      role: _currentUser!.role,
    );
    notifyListeners();
  }
} 