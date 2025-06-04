import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roteipro/models/route_model.dart';
import '../providers/route_provider.dart';
import '../widgets/route_card.dart';
import '../widgets/sidebar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RouteProvider>(context, listen: false).refreshRoutes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard de Rotas'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => Provider.of<RouteProvider>(context, listen: false)
                .refreshRoutes(),
          ),
        ],
      ),
      drawer: const Sidebar(),
      body: Consumer<RouteProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => provider.refreshRoutes(),
            child: Column(
              children: [
                _buildSearchAndFilter(provider),
                const SizedBox(height: 8),
                Expanded(
                  child: _buildRoutesList(provider),
                ),
                _buildPagination(provider),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/create-route');
          Provider.of<RouteProvider>(context, listen: false).refreshRoutes();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchAndFilter(RouteProvider provider) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Pesquisar rotas...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
            ),
            onChanged: provider.searchRoutes,
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: RouteProvider.statuses.map((status) {
                final isSelected = status == provider.currentStatus;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(status),
                    onSelected: (_) => provider.filterByStatus(status),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutesList(RouteProvider provider) {
    final routes = provider.dashboardRoutes;

    if (routes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.route_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            const Text(
              'Nenhuma rota encontrada',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: routes.length,
      itemBuilder: (context, index) {
        final route = routes[index];

        return GestureDetector(
          onLongPress: () => _showRouteActionsModal(context, route, provider),
          child: RouteCard(route: route),
        );
      },
    );
  }

  void _showRouteActionsModal(
      BuildContext context, RouteModel route, RouteProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        String selectedStatus = route.status;

        List<String> allStatus = [
          'Atrasada',
          'Cancelada',
          'Em andamento',
          'Pendente',
          'Concluída'
        ];

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Ações para "${route.name}"',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: allStatus
                    .map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedStatus = value;
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.all(9.0)),
                    onPressed: () async {
                      await provider.updateRouteStatus(
                          route.id, selectedStatus);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Status atualizado com sucesso!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    label: const Text('Atualizar Status'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.delete),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.all(9.0)),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirmar Exclusão'),
                          content:
                              const Text('Deseja realmente excluir esta rota?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Excluir'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await provider.deleteRoute(route.id);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Rota excluída com sucesso!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    label: const Text('Excluir Rota'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPagination(RouteProvider provider) {
    if (provider.totalPages <= 1) return const SizedBox.shrink();

    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: provider.currentPage > 0 ? provider.previousPage : null,
          ),
          Text(
            'Página ${provider.currentPage + 1} de ${provider.totalPages}',
            style: const TextStyle(fontSize: 16),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: provider.currentPage < provider.totalPages - 1
                ? provider.nextPage
                : null,
          ),
        ],
      ),
    );
  }
}
