import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:salobe_app/global/environment.dart';
import 'dart:convert';

import 'package:salobe_app/models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  List<Producto> _products = [];

  List<Producto> get products => _products;

  Future<void> fetchProducts() async {
    final url = Uri.parse('${Environment.apiUrl}/productos');
    try {
      final response =
          await http.get(url, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<Producto> productos =
            productosFromJson(jsonEncode(responseData["myProducts"]));
        _products = productos;
        notifyListeners();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      throw Exception('Error fetching products: $error');
    }
  }

  Future<void> createProduct(Producto newProduct) async {
    final url = Uri.parse('${Environment.apiUrl}/productos/new');

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'nombre': newProduct.nombre,
          'cantidad': newProduct.cantidad,
          'precio': newProduct.precio,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      await fetchProducts();
    } catch (error) {
      throw Exception('Error creating product: $error');
    }
  }
}
