import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/route_model.dart';
import '../providers/route_provider.dart';
import '../widgets/route_list_item.dart';
import '../widgets/sidebar.dart';
import '../widgets/statistics_panel.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedPeriod = 'Último Mês';
  final List<String> _periods = [
    'Última Semana',
    'Último Mês',
    'Últimos 3 Meses',
    'Último Ano'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RouteProvider>(context, listen: false).refreshRoutes();
    });
  }

  List<RouteModel> _filterRoutesByPeriod(List<RouteModel> routes) {
    final now = DateTime.now();
    DateTime startDate;

    switch (_selectedPeriod) {
      case 'Última Semana':
        startDate = now.subtract(const Duration(days: 7));
        break;
      case 'Último Mês':
        startDate = now.subtract(const Duration(days: 30));
        break;
      case 'Últimos 3 Meses':
        startDate = now.subtract(const Duration(days: 90));
        break;
      case 'Último Ano':
        startDate = now.subtract(const Duration(days: 365));
        break;
      default:
        startDate = now.subtract(const Duration(days: 30));
    }

    return routes.where((route) {
      return route.endDate.isAfter(startDate) && route.endDate.isBefore(now);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Rotas'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportHistory,
          ),
        ],
      ),
      drawer: const Sidebar(),
      body: Consumer<RouteProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final allCompletedRoutes = provider.routes!
              .where((route) => route.status == 'Concluída')
              .toList();
          final allCancelledRoutes = provider.routes!
              .where((route) => route.status == 'Cancelada')
              .toList();

          final filteredCompletedRoutes =
              _filterRoutesByPeriod(allCompletedRoutes);
          final filteredCancelledRoutes =
              _filterRoutesByPeriod(allCancelledRoutes);

          return RefreshIndicator(
            onRefresh: () => provider.refreshRoutes(),
            child: Column(
              children: [
                StatisticsPanel(
                  completedRoutes: filteredCompletedRoutes,
                  cancelledRoutes: filteredCancelledRoutes,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: DropdownButtonFormField<String>(
                    value: _selectedPeriod,
                    decoration: InputDecoration(
                      labelText: 'Período',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: _periods.map((period) {
                      return DropdownMenuItem(
                        value: period,
                        child: Text(period),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPeriod = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredCompletedRoutes.length +
                        filteredCancelledRoutes.length,
                    itemBuilder: (context, index) {
                      final route = index < filteredCompletedRoutes.length
                          ? filteredCompletedRoutes[index]
                          : filteredCancelledRoutes[
                              index - filteredCompletedRoutes.length];
                      return RouteListItem(route: route);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _exportHistory() async {
    // TODO: Implementar exportação em PDF/CSV
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exportação em desenvolvimento'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
