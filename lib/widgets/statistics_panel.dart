import 'package:flutter/material.dart';

import '../models/route_model.dart';

class StatisticsPanel extends StatelessWidget {
  final List<RouteModel> completedRoutes;
  final List<RouteModel> cancelledRoutes;

  const StatisticsPanel({
    Key? key,
    required this.completedRoutes,
    required this.cancelledRoutes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalDistance = completedRoutes.fold<double>(
      0,
      (sum, route) => sum + (route.distance),
    );

    final lastMonth = DateTime.now().subtract(const Duration(days: 30));
    final lastMonthRoutes = completedRoutes.where((route) {
      return route.endDate.isAfter(lastMonth);
    }).length;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Estatísticas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  'Concluídas',
                  completedRoutes.length.toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
                _buildStatItem(
                  context,
                  'Canceladas',
                  cancelledRoutes.length.toString(),
                  Icons.cancel,
                  Colors.red,
                ),
                _buildStatItem(
                  context,
                  'Total Km',
                  '${totalDistance.toStringAsFixed(0)} km',
                  Icons.map,
                  Colors.blue,
                ),
                _buildStatItem(
                  context,
                  'Último Mês',
                  lastMonthRoutes.toString(),
                  Icons.calendar_today,
                  Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
} 