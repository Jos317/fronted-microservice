import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salobe_app/models/cita_model.dart';
import 'package:salobe_app/services/Cita/cita_service.dart';
import 'package:salobe_app/services/Servicio/servicio_service.dart';
import 'package:salobe_app/services/System/auth_service.dart';

class CitaCrear extends StatefulWidget {
  const CitaCrear({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CitaCrearState createState() => _CitaCrearState();
}

class _CitaCrearState extends State<CitaCrear> {
  DateTime selectedDateTime = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String workerId = '';
  String clientId = '';
  List<String> serviceIds = [];
  String? selectedUser;
  List<Map<String, dynamic>> serviceDetails = [];

  @override
  void initState() {
    Provider.of<ServiceProvider>(context, listen: false).fetchServices();
    Provider.of<AuthService>(context, listen: false).fetchusuarios();
    super.initState();
  }

  void _selectDateTime() async {
    final DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDateTime != null && pickedDateTime != selectedDateTime) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );
      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDateTime.year,
            pickedDateTime.month,
            pickedDateTime.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _createCita() {
    final authService = Provider.of<AuthService>(context, listen: false);
    final usuario = authService.usuario;
    Cita newCita = Cita(fechahora: selectedDateTime.toString(), trabajadora: selectedUser!, cliente: usuario.uid);
    Provider.of<CitaProvider>(context, listen: false).createCita(newCita, serviceDetails);
    Navigator.pop(context);
    setState(() {
      serviceDetails = [];
    });
  }

  void _showAddDetailDialog() {
    String? selectedService;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final service = Provider.of<ServiceProvider>(context).services;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Agregar Servicio'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: selectedService,
                    hint: const Text('Seleccionar Servicio'),
                    onChanged: (value) {
                      setState(() {
                        selectedService = value;
                      });
                    },
                    items: service.map((service) {
                      return DropdownMenuItem(
                        value: service.id,
                        child: Text("${service.nombre} ${service.precio} Bs"),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (selectedService != null) {
                      setState(() {
                        serviceDetails.add({
                          'servicio': selectedService,
                        });
                      });
                      selectedService = null;
                    } else {}
                  },
                  child: const Text('Agregar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Guardar los detalles y cerrar el diálogo
                    Navigator.of(context).pop();
                  },
                  child: const Text('Guardar Detalles'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuarios = Provider.of<AuthService>(context).usuarios;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Cita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _selectDateTime,
              child: const Text('Seleccionar Fecha y Hora'),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedUser,
              hint: const Text('Seleccionar Trabajadora'),
              onChanged: (value) {
                setState(() {
                  selectedUser = value;
                });
              },
              items: usuarios.map((user) {
                return DropdownMenuItem(
                  value: user.uid,
                  child: Text(user.nombre),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showAddDetailDialog,
              child: const Text('Agregar Detalle'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createCita,
              child: const Text('Crear Cita'),
            ),
          ],
        ),
      ),
    );
  }
}
