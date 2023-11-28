import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:salobe_app/models/recibo_model.dart';
import 'package:salobe_app/services/Cita/cita_service.dart';
import 'package:salobe_app/services/Producto/producto_service.dart';
import 'package:salobe_app/services/Recibo/recibo_Service.dart';
import 'package:salobe_app/services/System/auth_service.dart';

class ReciboCrear extends StatefulWidget {
  const ReciboCrear({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ReciboCrearState createState() => _ReciboCrearState();
}

class _ReciboCrearState extends State<ReciboCrear> {
  DateTime selectedDateTime = DateTime.now();
  List<String> serviceIds = [];
  String? selectedCliente;
  String? selectedCita;
  List<Map<String, dynamic>> serviceDetails = [];

  @override
  void initState() {
    Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    Provider.of<CitaProvider>(context, listen: false).fetchAllCitas();
    Provider.of<AuthService>(context, listen: false).fetchClientes();
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

  double calcularCostoTotal(List<Map<String, dynamic>> productos) {
    double costoTotal = 0;

    for (var producto in productos) {
      int cantidad = producto['cantidad'];
      double precio = producto['precio'];
      double descuento = producto['descuento'];

      double precioConDescuento = precio * (1 - descuento);
      costoTotal += cantidad * precioConDescuento;
    }
    costoTotal = double.parse(costoTotal.toStringAsFixed(1));

    return costoTotal;
  }

  void _createCita() {
    final authService = Provider.of<AuthService>(context, listen: false);
    final usuario = authService.usuario;
    Recibo newRecibo = Recibo(
        fecha: selectedDateTime.toString(),
        total: calcularCostoTotal(serviceDetails),
        trabajadora: usuario.uid,
        cliente: selectedCliente!,
        cita: selectedCita!);
    Provider.of<ReciboProvider>(context, listen: false)
        .createRecibo(newRecibo, serviceDetails);
    Navigator.pop(context);
    setState(() {
      serviceDetails = [];
    });
  }

  void _showAddDetailDialog() {
    String? selectedProducto;
    String quantity = '';
    double servicePrice = 0;
    double descuento = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final productos = Provider.of<ProductProvider>(context).products;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Agregar Producto'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: selectedProducto,
                    hint: const Text('Seleccionar Producto'),
                    onChanged: (value) {
                      setState(() {
                        selectedProducto = value;
                      });
                    },
                    items: productos.map((producto) {
                      return DropdownMenuItem(
                        value: producto.id,
                        child: Text("${producto.nombre} ${producto.precio} Bs"),
                      );
                    }).toList(),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Cantidad'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      quantity = value;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Precio del Producto',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        servicePrice = double.tryParse(value) ?? 0;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Descuento',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        descuento = double.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (selectedProducto != null && quantity.isNotEmpty) {
                      setState(() {
                        serviceDetails.add({
                          'cantidad': int.tryParse(quantity) ?? 0,
                          'precio': servicePrice,
                          'descuento': descuento,
                          'producto': selectedProducto,
                        });
                      });
                      selectedProducto = null;
                      quantity = '';
                      servicePrice = 0;
                      descuento = 0;
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
    final clientes = Provider.of<AuthService>(context).clientes;
    final citas = Provider.of<CitaProvider>(context).allCitas;
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
              value: selectedCliente,
              hint: const Text('Seleccionar Cliente'),
              onChanged: (value) {
                setState(() {
                  selectedCliente = value;
                });
              },
              items: clientes.map((user) {
                return DropdownMenuItem(
                  value: user.uid,
                  child: Text(user.nombre),
                );
              }).toList(),
            ),
            DropdownButton<String>(
              value: selectedCita,
              hint: const Text('Seleccionar Cita'),
              onChanged: (value) {
                setState(() {
                  selectedCita = value;
                });
              },
              items: citas.map((cita) {
                DateTime dateTimeUTC = DateTime.parse(cita.fechahora);
                DateTime localDateTime = dateTimeUTC.toLocal();
                String formattedLocalTime =
                    DateFormat.yMMMMd('en_US').add_jms().format(localDateTime);
                return DropdownMenuItem(
                  value: cita.id,
                  child: Text(formattedLocalTime),
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
