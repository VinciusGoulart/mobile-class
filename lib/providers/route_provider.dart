import 'package:flutter/material.dart';

import '../models/route_model.dart';
import '../services/route_service.dart';

class RouteProvider with ChangeNotifier {
  final RouteService _routeService;
  List<RouteModel> _routes = [];
  List<RouteModel> _filteredRoutes = [];
  int _currentPage = 0;
  final int _itemsPerPage = 5;
  String _currentStatus = 'Todos';
  String _searchQuery = '';
  bool _isLoading = false;

  List<RouteModel> get routes => _routes;
  List<RouteModel> get filteredRoutes => _getPagedRoutes();
  List<RouteModel> get dashboardRoutes => _getDashboardRoutes();
  int get currentPage => _currentPage;
  int get totalPages => (_filteredRoutes.length / _itemsPerPage).ceil();
  String get currentStatus => _currentStatus;
  bool get isLoading => _isLoading;

  static final List<String> statuses = [
    'Todos',
    'Em andamento',
    'Atrasada',
    'Pendente'
  ];

  static final List<String> cities = [
    'São Paulo',
    'Rio de Janeiro',
    'Curitiba',
    'Salvador',
    'Belo Horizonte',
    'Porto Alegre',
    'Manaus',
    'Recife',
    'Brasília',
    'Fortaleza'
  ];

  RouteProvider({RouteService? routeService}) 
      : _routeService = routeService ?? RouteService() {
    _loadRoutes();
  }

  Future<void> _loadRoutes() async {
    _isLoading = true;
    notifyListeners();

    try {
      final routes = await _routeService.getRoutes('');
      _routes = routes;
      _applyFilters();
    } catch (e) {
      _routes = [];
      _filteredRoutes = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterByStatus(String status) {
    _currentStatus = status;
    _currentPage = 0;
    _applyFilters();
  }

  void searchRoutes(String query) {
    _searchQuery = query;
    _currentPage = 0;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredRoutes = _routes.where((route) {
      final matchesSearch = route.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          route.origin.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          route.destination.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesStatus = _currentStatus == 'Todos' || route.status == _currentStatus;
      
      return matchesSearch && matchesStatus;
    }).toList();
    notifyListeners();
  }

  List<RouteModel> _getPagedRoutes() {
    final start = _currentPage * _itemsPerPage;
    final end = start + _itemsPerPage;
    if (start >= _filteredRoutes.length) return [];
    return _filteredRoutes.sublist(start, end > _filteredRoutes.length ? _filteredRoutes.length : end);
  }

  List<RouteModel> _getDashboardRoutes() {
    // Primeiro filtra as rotas que não são concluídas
    var filtered = _routes.where((route) => route.status != 'Concluída').toList();
    
    // Aplica o filtro de status
    if (_currentStatus != 'Todos') {
      filtered = filtered.where((route) => route.status == _currentStatus).toList();
    }
    
    // Aplica a pesquisa
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((route) {
        return route.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               route.origin.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               route.destination.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
    
    // Aplica a paginação
    final start = _currentPage * _itemsPerPage;
    final end = start + _itemsPerPage;
    if (start >= filtered.length) return [];
    return filtered.sublist(start, end > filtered.length ? filtered.length : end);
  }

  void nextPage() {
    if (_currentPage < totalPages - 1) {
      _currentPage++;
      notifyListeners();
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      notifyListeners();
    }
  }

  Future<void> refreshRoutes() async {
    await _loadRoutes();
  }

  Future<bool> createRoute(RouteModel route) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _routeService.createRoute(route);
      if (success) {
        _routes.add(route);
        _applyFilters();
      }
      return success;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 