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
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _originController.dispose();
    _destinationController.dispose();
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
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _createRoute() async {
    if (_formKey.currentState!.validate()) {
      final routeProvider = Provider.of<RouteProvider>(context, listen: false);

      final route = RouteModel(
        id: '',
        userId: '',
        name: _titleController.text.trim(),
        status: 'Pendente', 
        startDate: _selectedDate,
        endDate: _selectedDate.add(const Duration(days: 1)),
        distance: 100, 
        origin: _originController.text.trim(),
        destination: _destinationController.text.trim(),
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
                  'Data de início: ${_selectedDate.toString().split(' ')[0]}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _selectDate(context),
                ),
              ),
              const SizedBox(height: 24),
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
