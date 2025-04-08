import 'package:get_it/get_it.dart';
import '../services/auth_service.dart';
import '../services/route_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Registrando o AuthService como um singleton
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  
  // Registrando o RouteService como um singleton
  getIt.registerLazySingleton<RouteService>(() => RouteService());
} 