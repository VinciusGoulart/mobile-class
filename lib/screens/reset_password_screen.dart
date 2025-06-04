// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/password_recovery_provider.dart';

// class ResetPasswordScreen extends StatefulWidget {
//   const ResetPasswordScreen({super.key});

//   @override
//   State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
// }

// class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;

//   @override
//   void dispose() {
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   String? _validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'O campo de senha não pode estar vazio.';
//     }
//     if (value.length < 6) {
//       return 'A senha deve ter pelo menos 6 caracteres.';
//     }
//     return null;
//   }

//   String? _validateConfirmPassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'O campo de confirmação não pode estar vazio.';
//     }
//     if (value != _passwordController.text) {
//       return 'As senhas não coincidem.';
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<PasswordRecoveryProvider>(context);
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Nova Senha'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const SizedBox(height: 32),
//               Text(
//                 'Crie uma nova senha para sua conta',
//                 style: theme.textTheme.bodyLarge,
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 32),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: InputDecoration(
//                   labelText: 'Nova Senha',
//                   prefixIcon: const Icon(Icons.lock),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscurePassword ? Icons.visibility : Icons.visibility_off,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _obscurePassword = !_obscurePassword;
//                       });
//                     },
//                   ),
//                 ),
//                 obscureText: _obscurePassword,
//                 validator: _validatePassword,
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _confirmPasswordController,
//                 decoration: InputDecoration(
//                   labelText: 'Confirmar Nova Senha',
//                   prefixIcon: const Icon(Icons.lock),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscureConfirmPassword
//                           ? Icons.visibility
//                           : Icons.visibility_off,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _obscureConfirmPassword = !_obscureConfirmPassword;
//                       });
//                     },
//                   ),
//                 ),
//                 obscureText: _obscureConfirmPassword,
//                 validator: _validateConfirmPassword,
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: () async {
//                   // if (_formKey.currentState!.validate()) {
//                   //   final success = await provider.resetPassword(
//                   //     _passwordController.text,
//                   //   );
//                   //   if (success && context.mounted) {
//                   //     ScaffoldMessenger.of(context).showSnackBar(
//                   //       const SnackBar(
//                   //         content: Text('Senha alterada com sucesso'),
//                   //         backgroundColor: Colors.green,
//                   //       ),
//                   //     );
//                   //     Navigator.pushNamedAndRemoveUntil(
//                   //       context,
//                   //       '/login',
//                   //       (route) => false,
//                   //     );
//                   //   }
//                   // }
//                 },
//                 child: const Text('Confirmar'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// } 