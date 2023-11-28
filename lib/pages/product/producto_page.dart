import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salobe_app/models/product_model.dart';
import 'package:salobe_app/pages/Home/menu.dart';
import 'package:salobe_app/pages/product/producto_crear.dart';
import 'package:salobe_app/services/Producto/producto_service.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {

  @override
  void initState() {
    Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final producto = Provider.of<ProductProvider>(context).products;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateProductPage()),
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: producto.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(producto[index].nombre),
              subtitle: Text("${producto[index].cantidad.toString()} Disponibles"),
              trailing: Text(
                "${producto[index].precio.toString()} Bs",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                _showProductDetails(producto[index]);
              },
            ),
          );
        },
      ),
    );
  }

  void _showProductDetails(Producto product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(product.nombre),
          content: Text('Cantidad: ${product.cantidad.toString()}\nPrecio: ${product.precio} Bs'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}