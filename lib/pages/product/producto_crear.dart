import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salobe_app/models/product_model.dart';
import 'package:salobe_app/services/Producto/producto_service.dart';

class CreateProductPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController();

  CreateProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: cantidadController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cantidad',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Precio',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _createProduct(context);
              },
              child: const Text('Crear producto'),
            ),
          ],
        ),
      ),
    );
  }

  void _createProduct(BuildContext context) {
    final String name = nameController.text;
    final double price = double.tryParse(priceController.text) ?? 0.0;
    final String cantidad = cantidadController.text;
    Producto newProduct = Producto(nombre: name, cantidad: int.parse(cantidad), precio: price);
    Provider.of<ProductProvider>(context, listen: false).createProduct(newProduct);
    Navigator.pop(context);
  }
}