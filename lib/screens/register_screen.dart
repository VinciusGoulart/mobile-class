import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/register_provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterProvider(),
      child: const _RegisterScreenContent(),
    );
  }
}

class _RegisterScreenContent extends StatelessWidget {
  const _RegisterScreenContent();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegisterProvider>(context);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 24.0 : size.width * 0.1,
              vertical: 24.0,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: provider.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    // Logo placeholder
                    Container(
                      height: isSmallScreen ? 120 : 160,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.public,
                            size: isSmallScreen ? 80 : 100,
                            color: theme.colorScheme.primary,
                          ),
                          Icon(
                            Icons.local_shipping,
                            size: isSmallScreen ? 40 : 50,
                            color: theme.colorScheme.secondary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Criar Conta',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: provider.nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        prefixIcon: Icon(Icons.person),
                        hintText: 'Digite seu nome',
                      ),
                      textInputAction: TextInputAction.next,
                      validator: provider.validateName,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: provider.emailController,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.email),
                        hintText: 'Digite seu e-mail',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: provider.validateEmail,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: provider.phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Telefone',
                        prefixIcon: Icon(Icons.phone),
                        hintText: 'Digite seu telefone',
                      ),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [provider.phoneMask],
                      validator: provider.validatePhone,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: provider.passwordController,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: const Icon(Icons.lock),
                        hintText: 'Digite sua senha',
                        suffixIcon: IconButton(
                          icon: Icon(
                            provider.obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: provider.togglePasswordVisibility,
                        ),
                      ),
                      obscureText: provider.obscurePassword,
                      textInputAction: TextInputAction.next,
                      validator: provider.validatePassword,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: provider.confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirmar Senha',
                        prefixIcon: const Icon(Icons.lock),
                        hintText: 'Confirme sua senha',
                        suffixIcon: IconButton(
                          icon: Icon(
                            provider.obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: provider.toggleConfirmPasswordVisibility,
                        ),
                      ),
                      obscureText: provider.obscureConfirmPassword,
                      textInputAction: TextInputAction.done,
                      validator: provider.validateConfirmPassword,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () async {
                              final success = await provider.register(context);
                              if (success) {
                                Navigator.pushReplacementNamed(context, '/login');
                              }
                            },
                      child: provider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Cadastrar'),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Já tem uma conta? Faça login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 