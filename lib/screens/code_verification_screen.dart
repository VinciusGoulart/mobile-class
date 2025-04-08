import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import '../providers/password_recovery_provider.dart';

class CodeVerificationScreen extends StatefulWidget {
  const CodeVerificationScreen({super.key});

  @override
  State<CodeVerificationScreen> createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  String _enteredCode = '';
  bool _isInvalidCode = false;

  void _validateCode() {
    if (_enteredCode.length == 6) {
      final provider = Provider.of<PasswordRecoveryProvider>(context, listen: false);
      if (provider.validateCode(_enteredCode)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamed(context, '/reset-password');
        });
      } else {
        setState(() {
          _isInvalidCode = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PasswordRecoveryProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificar Código'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            Text(
              'Digite o código de 6 dígitos enviado para seu e-mail',
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Center(
              child: VerificationCode(
                length: 6,
                textStyle: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ) ?? const TextStyle(fontSize: 20),
                underlineColor: theme.colorScheme.primary,
                keyboardType: TextInputType.number,
                onCompleted: (String value) {
                  setState(() {
                    _enteredCode = value;
                    _isInvalidCode = false;
                  });
                  _validateCode();
                },
                onEditing: (bool value) {
                  if (!value) {
                    setState(() {
                      _isInvalidCode = false;
                    });
                  }
                },
              ),
            ),
            if (_isInvalidCode)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Código inválido. Tente novamente.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _validateCode,
              child: const Text('Validar Código'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: provider.timer > 0
                  ? null
                  : () async {
                      final success = await provider.sendCode();
                      if (success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Código reenviado com sucesso'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
              child: Text(
                provider.timer > 0
                    ? 'Aguarde ${provider.timer}s para reenviar'
                    : 'Reenviar Código',
              ),
            ),
          ],
        ),
      ),
    );
  }
} 