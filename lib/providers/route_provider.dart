import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/route_model.dart';

class RouteProvider with ChangeNotifier {
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

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  Future<void> _loadRoutes() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        _routes = [];
        _filteredRoutes = [];
        return;
      }

      final snapshot = await _firestore
          .collection('routes')
          .where('userId', isEqualTo: userId)
          .get();

      _routes = snapshot.docs.map((doc) {
        final data = doc.data();
        return RouteModel.fromJson({...data, 'id': doc.id});
      }).toList();

      _applyFilters();
    } catch (e) {
      debugPrint('Erro ao carregar rotas: $e');
      _routes = [];
      _filteredRoutes = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createRoute(RouteModel route) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      final docRef = _firestore.collection('routes').doc();

      final newRoute = route.copyWith(
        id: docRef.id,
        userId: userId,
      );

      await docRef.set(newRoute.toJson());

      _routes.add(newRoute);
      _applyFilters();

      final notificationRef = _firestore.collection('notifications').doc();
      await notificationRef.set({
        'id': notificationRef.id,
        'userId': userId,
        'title': 'Nova rota criada',
        'description': 'Sua rota "${newRoute.name}" foi criada com sucesso.',
        'date': DateTime.now().toIso8601String(),
        'isRead': false,
      });

      return true;
    } catch (e) {
      debugPrint('Erro ao criar rota: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateRouteStatus(String routeId, String newStatus) async {
    try {
      await _firestore.collection('routes').doc(routeId).update({
        'status': newStatus,
      });

      final index = _routes.indexWhere((r) => r.id == routeId);
      if (index != -1) {
        _routes[index] = _routes[index].copyWith(status: newStatus);
        _applyFilters();
      }

      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        final notificationRef = _firestore.collection('notifications').doc();
        await notificationRef.set({
          'id': notificationRef.id,
          'userId': userId,
          'title': 'Status atualizado',
          'description':
              'O status da rota "${_routes[index].name}" foi alterado para $newStatus.',
          'date': DateTime.now().toIso8601String(),
          'isRead': false,
        });
      }
    } catch (e) {
      debugPrint('Erro ao atualizar status: $e');
    }
  }

  Future<void> deleteRoute(String routeId) async {
    try {
      await _firestore.collection('routes').doc(routeId).delete();

      final index = _routes.indexWhere((r) => r.id == routeId);
      if (index != -1) {
        final routeName = _routes[index].name;
        _routes.removeAt(index);
        _applyFilters();

        final userId = _auth.currentUser?.uid;
        if (userId != null) {
          final notificationRef = _firestore.collection('notifications').doc();
          await notificationRef.set({
            'id': notificationRef.id,
            'userId': userId,
            'title': 'Rota excluída',
            'description': 'A rota "$routeName" foi excluída.',
            'date': DateTime.now().toIso8601String(),
            'isRead': false,
          });
        }
      }
    } catch (e) {
      debugPrint('Erro ao excluir rota: $e');
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
      final matchesSearch = route.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          route.origin.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          route.destination.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesStatus =
          _currentStatus == 'Todos' || route.status == _currentStatus;

      return matchesSearch && matchesStatus;
    }).toList();
    notifyListeners();
  }

  List<RouteModel> _getPagedRoutes() {
    final start = _currentPage * _itemsPerPage;
    final end = start + _itemsPerPage;
    if (start >= _filteredRoutes.length) return [];
    return _filteredRoutes.sublist(
        start, end > _filteredRoutes.length ? _filteredRoutes.length : end);
  }

  List<RouteModel> _getDashboardRoutes() {
    var filtered =
        _routes.where((route) => route.status != 'Concluída' && route.status != 'Cancelada').toList();

    if (_currentStatus != 'Todos') {
      filtered =
          filtered.where((route) => route.status == _currentStatus).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((route) {
        return route.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            route.origin.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            route.destination
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
      }).toList();
    }

    final start = _currentPage * _itemsPerPage;
    final end = start + _itemsPerPage;
    if (start >= filtered.length) return [];
    return filtered.sublist(
        start, end > filtered.length ? filtered.length : end);
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
}
