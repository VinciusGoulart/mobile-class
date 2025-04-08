import 'package:flutter/material.dart';

import '../helpers/service_locator.dart';
import '../services/auth_service.dart';

class LoginController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  bool get obscurePassword => _obscurePassword;
  bool get isLoading => _isLoading;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'O campo de e-mail não pode estar vazio.';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'E-mail inválido.';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'O campo de senha não pode estar vazio.';
    }
    if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres.';
    }
    return null;
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<bool> login(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      _isLoading = true;
      notifyListeners();
      
      try {
        final authService = getIt<AuthService>();
        final success = await authService.login(
          emailController.text,
          passwordController.text,
        );
        
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login realizado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('E-mail ou senha inválidos.'),
              backgroundColor: Colors.red,
            ),
          );
          _isLoading = false;
          notifyListeners();
          return false;
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao realizar login. Tente novamente.'),
            backgroundColor: Colors.red,
          ),
        );
        _isLoading = false;
        notifyListeners();
        return false;
      }
    }
    return false;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
} 