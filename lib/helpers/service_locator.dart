import 'package:get_it/get_it.dart';
import 'package:roteipro/providers/notification_provider.dart';
import '../providers/auth_provider.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Registrando o AuthProvider como um singleton
  getIt.registerLazySingleton<AuthProvider>(() => AuthProvider());
  getIt.registerLazySingleton<NotificationProvider>(() => NotificationProvider());  
} 