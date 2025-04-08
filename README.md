# RoteiPro

## 📱 Descrição
O RoteiPro é um aplicativo móvel desenvolvido em Flutter para gerenciamento e rastreamento de rotas de caminhoneiros. O sistema oferece uma solução completa para o planejamento, acompanhamento e análise de rotas, proporcionando maior eficiência e segurança no transporte de cargas.

## 🎯 Objetivo
O objetivo principal do RoteiPro é otimizar o processo de gerenciamento de rotas para caminhoneiros, oferecendo:
- Planejamento eficiente de rotas
- Acompanhamento em tempo real
- Histórico detalhado de viagens
- Gestão de perfil do usuário
- Análise de desempenho

## 🛠️ Ferramentas Necessárias

### Desenvolvimento
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (versão 3.0.0 ou superior)
- [Dart SDK](https://dart.dev/get-dart) (versão 2.17.0 ou superior)
- [Android Studio](https://developer.android.com/studio) ou [Visual Studio Code](https://code.visualstudio.com/)
- [Git](https://git-scm.com/downloads)

### Extensões Recomendadas (VS Code)
- Flutter
- Dart
- Pubspec Assist
- Error Lens
- Bracket Pair Colorizer

## 🚀 Como Iniciar o Projeto

1. **Pré-requisitos**
   ```bash
   # Verifique se o Flutter está instalado
   flutter --version

   # Verifique se o Android Studio está configurado
   flutter doctor
   ```

2. **Clonar o Repositório**
   ```bash
   git clone https://github.com/seu-usuario/roteipro.git
   cd roteipro
   ```

3. **Instalar Dependências**
   ```bash
   flutter pub get
   ```

4. **Configurar Ambiente**
   - Certifique-se de que o Android NDK está instalado (versão 27.0.12077973)
   - Configure o emulador Android ou conecte um dispositivo físico

5. **Executar o Projeto**
   ```bash
   flutter run
   ```

## 📁 Estrutura do Projeto

```
lib/
  ├── screens/          # Telas do aplicativo
  │   ├── auth/        # Telas de autenticação
  │   ├── home/        # Telas principais
  │   └── profile/     # Telas de perfil
  ├── widgets/         # Componentes reutilizáveis
  ├── models/          # Modelos de dados
  ├── services/        # Serviços e lógica de negócios
  ├── providers/       # Gerenciamento de estado
  └── utils/           # Utilitários e helpers
```

## 🔑 Credenciais de Teste

Para testar o aplicativo, utilize as seguintes credenciais:
- Email: admin@example.com
- Senha: 123456

## 📝 Funcionalidades Implementadas

- [x] Autenticação de usuários
- [x] Gerenciamento de perfil
- [x] Criação e edição de rotas
- [x] Dashboard com estatísticas
- [x] Histórico de rotas
- [x] Configurações do usuário
- [x] Modo escuro
- [x] Suporte a múltiplos idiomas

## 🔄 Próximas Funcionalidades

- [ ] Integração com API de mapas
- [ ] Rastreamento em tempo real
- [ ] Notificações push
- [ ] Relatórios detalhados
- [ ] Exportação de dados

## 🤝 Contribuição

Contribuições são bem-vindas! Para contribuir:

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.


