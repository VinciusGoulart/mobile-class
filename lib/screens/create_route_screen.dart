import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/route_model.dart';
import '../providers/route_provider.dart';

class CreateRouteScreen extends StatefulWidget {
  const CreateRouteScreen({super.key});

  @override
  State<CreateRouteScreen> createState() => _CreateRouteScreenState();
}

class _CreateRouteScreenState extends State<CreateRouteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  final _stops = <String>[];
  final _stopController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _originController.dispose();
    _destinationController.dispose();
    _stopController.dispose();
    super.dispose();
  }

  String? _validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'O campo $fieldName é obrigatório';
    }
    return null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addStop() {
    if (_stopController.text.isNotEmpty) {
      setState(() {
        _stops.add(_stopController.text);
        _stopController.clear();
      });
    }
  }

  void _removeStop(int index) {
    setState(() {
      _stops.removeAt(index);
    });
  }

  Future<void> _createRoute() async {
    if (_formKey.currentState!.validate()) {
      final routeProvider = Provider.of<RouteProvider>(context, listen: false);

      final route = RouteModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _titleController.text,
        status: 'Pendente',
        startDate: _selectedDate,
        endDate: _selectedDate.add(const Duration(days: 1)),
        distance: 0,
        origin: _originController.text,
        destination: _destinationController.text,
      );

      final success = await routeProvider.createRoute(route);

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Rota criada com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro ao criar rota. Tente novamente.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final routeProvider = Provider.of<RouteProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Rota'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) => _validateField(value, 'título'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (value) => _validateField(value, 'descrição'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _originController,
                decoration: const InputDecoration(
                  labelText: 'Origem',
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) => _validateField(value, 'origem'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _destinationController,
                decoration: const InputDecoration(
                  labelText: 'Destino',
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) => _validateField(value, 'destino'),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  'Data: ${_selectedDate.toString().split(' ')[0]}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _selectDate(context),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _stopController,
                      decoration: const InputDecoration(
                        labelText: 'Adicionar Parada',
                        prefixIcon: Icon(Icons.add_location),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addStop,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_stops.isNotEmpty) ...[
                Text(
                  'Paradas',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _stops.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        child: Text('${index + 1}'),
                      ),
                      title: Text(_stops[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        color: Colors.red,
                        onPressed: () => _removeStop(index),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
              ElevatedButton(
                onPressed: routeProvider.isLoading ? null : _createRoute,
                child: routeProvider.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Criar Rota'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 