import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salobe_app/models/servicio_model.dart';
import 'package:salobe_app/services/Producto/producto_service.dart';
import 'package:salobe_app/services/Servicio/servicio_service.dart';

class ServicioCrear extends StatefulWidget {
  const ServicioCrear({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ServicioCrearState createState() => _ServicioCrearState();
}

class _ServicioCrearState extends State<ServicioCrear> {
  String serviceName = '';
  double servicePrice = 0;
  List<Map<String, dynamic>> serviceDetails = [];

  @override
  void initState() {
    Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    super.initState();
  }

  void _createService() {
    Servicio newServicio = Servicio(nombre: serviceName,precio: servicePrice);
    Provider.of<ServiceProvider>(context, listen: false).createServicio(newServicio, serviceDetails);
    Navigator.pop(context);
    setState(() {
      serviceName = '';
      servicePrice = 0;
      serviceDetails = [];
    });
  }

  void _showAddDetailDialog() {
    String? selectedProduct;
    String quantity = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final producto = Provider.of<ProductProvider>(context).products;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Agregar Detalle'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: selectedProduct,
                    hint: const Text('Seleccionar Producto'),
                    onChanged: (value) {
                      setState(() {
                        selectedProduct = value;
                      });
                    },
                    items: producto.map((product) {
                      return DropdownMenuItem(
                        value: product.id, // Aquí asumimos que tienes un campo 'id' en tu modelo de Producto
                        child: Text(product.nombre),
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
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (selectedProduct != null && quantity.isNotEmpty) {
                      setState(() {
                        serviceDetails.add({
                          'cantidad': int.tryParse(quantity) ?? 0,
                          'producto': selectedProduct,
                        });
                      });
                      // Limpiar los campos para agregar otro detalle
                      selectedProduct = null;
                      quantity = '';
                    } else {
                      // Mostrar un mensaje de error o requerir campos adicionales
                    }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Servicio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nombre del Servicio',
              ),
              onChanged: (value) {
                setState(() {
                  serviceName = value;
                });
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Precio del Servicio',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  servicePrice = double.tryParse(value) ?? 0;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showAddDetailDialog,
              child: const Text('Agregar Detalle'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createService,
              child: const Text('Crear Servicio'),
            ),
          ],
        ),
      ),
    );
  }
}
