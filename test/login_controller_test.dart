import 'package:flutter_test/flutter_test.dart';
import 'package:roteipro/controllers/login_controller.dart';

void main() {
  late LoginController controller;

  setUp(() {
    controller = LoginController();
  });

  tearDown(() {
    controller.dispose();
  });

  group('LoginController - Validação de E-mail', () {
    test('Deve retornar mensagem de erro quando o e-mail está vazio', () {
      expect(controller.validateEmail(''), 'O campo de e-mail não pode estar vazio.');
    });

    test('Deve retornar mensagem de erro quando o e-mail é inválido', () {
      expect(controller.validateEmail('email@'), 'E-mail inválido.');
      expect(controller.validateEmail('email@teste'), 'E-mail inválido.');
      expect(controller.validateEmail('email@teste.'), 'E-mail inválido.');
    });

    test('Deve retornar null quando o e-mail é válido', () {
      expect(controller.validateEmail('teste@teste.com'), null);
      expect(controller.validateEmail('teste@teste.com.br'), null);
    });
  });

  group('LoginController - Validação de Senha', () {
    test('Deve retornar mensagem de erro quando a senha está vazia', () {
      expect(controller.validatePassword(''), 'O campo de senha não pode estar vazio.');
    });

    test('Deve retornar mensagem de erro quando a senha tem menos de 6 caracteres', () {
      expect(controller.validatePassword('12345'), 'A senha deve ter pelo menos 6 caracteres.');
    });

    test('Deve retornar null quando a senha é válida', () {
      expect(controller.validatePassword('123456'), null);
      expect(controller.validatePassword('senha123'), null);
    });
  });

  group('LoginController - Estado do Formulário', () {
    test('Deve inicializar com os campos vazios', () {
      expect(controller.emailController.text, '');
      expect(controller.passwordController.text, '');
    });

    test('Deve inicializar com a senha oculta', () {
      expect(controller.obscurePassword, true);
    });

    test('Deve inicializar sem carregamento', () {
      expect(controller.isLoading, false);
    });
  });
} 