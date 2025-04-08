import 'package:flutter/material.dart';
import '../models/route_model.dart';

class RouteService extends ChangeNotifier {
  bool _isLoading = false;
  List<RouteModel> _routes = [];

  bool get isLoading => _isLoading;
  List<RouteModel> get routes => _routes;

  Future<bool> createRoute(RouteModel route) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implementar chamada real à API
      await Future.delayed(const Duration(seconds: 2));

      _routes.add(route);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateRoute(RouteModel route) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implementar chamada real à API
      await Future.delayed(const Duration(seconds: 2));

      final index = _routes.indexWhere((r) => r.id == route.id);
      if (index != -1) {
        _routes[index] = route;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteRoute(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implementar chamada real à API
      await Future.delayed(const Duration(seconds: 2));

      _routes.removeWhere((r) => r.id == id);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<List<RouteModel>> getRoutes(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implementar chamada real à API
      await Future.delayed(const Duration(seconds: 2));

      // Simulando dados
      _routes = [
        RouteModel(
          id: '1',
          name: 'Rota 1',
          status: 'Pendente',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 1)),
          distance: 150,
          origin: 'São Paulo, SP',
          destination: 'Campinas, SP',
        ),
        RouteModel(
          id: '2',
          name: 'Rota 2',
          status: 'Em andamento',
          startDate: DateTime.now().subtract(const Duration(days: 1)),
          endDate: DateTime.now().add(const Duration(days: 3)),
          distance: 300,
          origin: 'Curitiba, PR',
          destination: 'Porto Alegre, RS',
        ),
        RouteModel(
          id: '3',
          name: 'Rota 3',
          status: 'Concluída',
          startDate: DateTime.now().subtract(const Duration(days: 20)),
          endDate: DateTime.now().subtract(const Duration(days: 25)),
          distance: 220,
          origin: 'Belo Horizonte, MG',
          destination: 'Vitória, ES',
        ),
        RouteModel(
          id: '4',
          name: 'Rota 4',
          status: 'Atrasada',
          startDate: DateTime.now().subtract(const Duration(days: 2)),
          endDate: DateTime.now().subtract(const Duration(days: 1)),
          distance: 180,
          origin: 'Recife, PE',
          destination: 'João Pessoa, PB',
        ),
        RouteModel(
          id: '5',
          name: 'Rota 5',
          status: 'Em andamento',
          startDate: DateTime.now().subtract(const Duration(hours: 6)),
          endDate: DateTime.now().add(const Duration(days: 1)),
          distance: 120,
          origin: 'Fortaleza, CE',
          destination: 'Natal, RN',
        ),
        RouteModel(
          id: '6',
          name: 'Rota 6',
          status: 'Concluída',
          startDate: DateTime.now().subtract(const Duration(days: 7)),
          endDate: DateTime.now().subtract(const Duration(days: 5)),
          distance: 400,
          origin: 'Manaus, AM',
          destination: 'Boa Vista, RR',
        ),
        RouteModel(
          id: '7',
          name: 'Rota 7',
          status: 'Pendente',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 4)),
          distance: 275,
          origin: 'Brasília, DF',
          destination: 'Goiânia, GO',
        ),
        RouteModel(
          id: '8',
          name: 'Rota 8',
          status: 'Atrasada',
          startDate: DateTime.now().subtract(const Duration(days: 3)),
          endDate: DateTime.now().subtract(const Duration(days: 1)),
          distance: 350,
          origin: 'Florianópolis, SC',
          destination: 'Blumenau, SC',
        ),
        RouteModel(
          id: '9',
          name: 'Rota 9',
          status: 'Em andamento',
          startDate: DateTime.now().subtract(const Duration(days: 1)),
          endDate: DateTime.now().add(const Duration(days: 2)),
          distance: 500,
          origin: 'Salvador, BA',
          destination: 'Aracaju, SE',
        ),
        RouteModel(
          id: '10',
          name: 'Rota 10',
          status: 'Concluída',
          startDate: DateTime.now().subtract(const Duration(days: 10)),
          endDate: DateTime.now().subtract(const Duration(days: 7)),
          distance: 600,
          origin: 'Belém, PA',
          destination: 'Macapá, AP',
        ),
      ];

      _isLoading = false;
      notifyListeners();
      return _routes;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }
}
