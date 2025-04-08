import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../widgets/sidebar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        centerTitle: true,
      ),
      drawer: const Sidebar(),
      body: ListView(
        children: [
          // Seção Conta
          _buildSectionHeader('Conta', theme),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Editar Perfil'),
            onTap: () {
              Navigator.pushNamed(context, '/edit-profile');
            },
          ),
     
          
          const Divider(),

          // Preferências do Aplicativo
          _buildSectionHeader('Preferências do Aplicativo', theme),
          SwitchListTile(
            title: const Text('Modo Escuro'),
            value: settingsProvider.isDarkMode,
            onChanged: (value) {
              settingsProvider.toggleDarkMode();
            },
            secondary: const Icon(Icons.brightness_6),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Idioma'),
            subtitle: Text(settingsProvider.language == 'pt' ? 'Português' : 'English'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Selecione o idioma'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: const Text('Português'),
                        onTap: () {
                          settingsProvider.setLanguage('pt');
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('English'),
                        onTap: () {
                          settingsProvider.setLanguage('en');
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SwitchListTile(
            title: const Text('Notificações'),
            value: settingsProvider.notificationsEnabled,
            onChanged: (value) {
              settingsProvider.toggleNotifications();
            },
            secondary: const Icon(Icons.notifications),
          ),

          const Divider(),

          // Privacidade e Segurança
          _buildSectionHeader('Privacidade e Segurança', theme),
          SwitchListTile(
            title: const Text('Autenticação de Dois Fatores'),
            value: settingsProvider.twoFactorEnabled,
            onChanged: (value) {
              settingsProvider.toggleTwoFactor();
            },
            secondary: const Icon(Icons.security),
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Excluir Conta', style: TextStyle(color: Colors.red)),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Excluir Conta'),
                  content: const Text('Tem certeza que deseja excluir sua conta? Esta ação não pode ser desfeita.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Implementar exclusão de conta
                        Navigator.pop(context);
                      },
                      child: const Text('Excluir', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),

          const Divider(),

          // Dados e Backup
          _buildSectionHeader('Dados e Backup', theme),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Exportar Dados'),
            onTap: () {
              settingsProvider.exportData();
            },
          ),
          ListTile(
            leading: const Icon(Icons.cleaning_services),
            title: const Text('Limpar Cache'),
            onTap: () {
              settingsProvider.clearCache();
            },
          ),

          const Divider(),

          // Sobre o Aplicativo
          _buildSectionHeader('Sobre o Aplicativo', theme),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Versão'),
            subtitle: const Text('1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.policy),
            title: const Text('Termos e Privacidade'),
            onTap: () {
              Navigator.pushNamed(context, '/terms');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
} 