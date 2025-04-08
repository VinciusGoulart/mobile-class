import 'dart:async';

import 'package:flutter/material.dart';

class PasswordRecoveryProvider with ChangeNotifier {
  String _email = '';
  int _timer = 30;
  bool _codeSent = false;
  Timer? _countdownTimer;
  final String _mockCode = '123456';

  String get email => _email;
  int get timer => _timer;
  bool get codeSent => _codeSent;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void startTimer() {
    _timer = 30;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timer > 0) {
        _timer--;
        notifyListeners();
      } else {
        timer.cancel();
        _codeSent = false;
        notifyListeners();
      }
    });
  }

  Future<bool> sendCode() async {
    _codeSent = true;
    startTimer();
    // TODO: Implementar envio real de e-mail
    await Future.delayed(const Duration(seconds: 1)); // Simulação de envio
    notifyListeners();
    return true;
  }

  bool validateCode(String inputCode) {
    return inputCode == _mockCode;
  }

  Future<bool> resetPassword(String newPassword) async {
    // TODO: Implementar reset real de senha
    await Future.delayed(const Duration(seconds: 1)); // Simulação de reset
    return true;
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }
} 