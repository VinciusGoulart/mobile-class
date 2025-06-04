import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordRecoveryProvider with ChangeNotifier {
  String _email = '';

  final FirebaseAuth auth = FirebaseAuth.instance;

  String get email => _email;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  resetPassword(BuildContext context, String email) {
    auth.sendPasswordResetEmail(email: email).then((resultado) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.greenAccent.withValues(alpha: 0.4),
        content: const Text(
          'E-mail enviado com sucesso!',
          style: TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 3),
      ));
      Navigator.pop(context);
    }).catchError((e) {
      String mensagem;
      switch (e.code) {
        case 'invalid-email':
          mensagem = 'O e-mail informado é inválido.';
          break;
        case 'user-not-found':
          mensagem = 'Nenhum usuário encontrado com este e-mail.';
          break;
        default:
          mensagem = 'Erro: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent.withValues(alpha: 0.4),
        content: Text(
          mensagem,
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 3),
      ));
    });
  }
}
