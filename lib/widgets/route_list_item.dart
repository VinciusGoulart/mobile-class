import 'package:flutter/material.dart';

import '../models/route_model.dart';

class RouteListItem extends StatelessWidget {
  final RouteModel route;

  const RouteListItem({
    Key? key,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCompleted = route.status == 'Concluída';
    final icon = isCompleted ? Icons.check_circle : Icons.cancel;
    final color = isCompleted ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          route.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Origem: ${route.origin}'),
            Text('Destino: ${route.destination}'),
            Text('Distância: ${route.distance.toStringAsFixed(0)} km'),
            Text(
              'Período: ${_formatDate(route.startDate)} - ${_formatDate(route.endDate)}',
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
} 