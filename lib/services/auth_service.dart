import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  bool _isAuthenticated = false;
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  bool get isAuthenticated => _isAuthenticated;
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

  Future<bool> register(UserModel user) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implementar chamada real à API
      await Future.delayed(const Duration(seconds: 2));
      
      _currentUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: user.name,
        email: user.email,
        phone: user.phone,
        password: user.password,
        role: 'admin',
      );
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulando uma chamada de API
      await Future.delayed(const Duration(seconds: 2));
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Erro ao recuperar senha: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }

  Future<void> updateUser(UserModel user) async {
    _currentUser = user;
    notifyListeners();
  }
} 