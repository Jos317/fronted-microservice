import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:salobe_app/global/environment.dart';
import 'dart:convert';

import 'package:salobe_app/models/servicio_model.dart';

class ServiceProvider extends ChangeNotifier {
  List<Servicio> _services = [];

  List<Servicio> get services => _services;

  Future<void> fetchServices() async {
    final url = Uri.parse('${Environment.apiUrl}/servicios');
    try {
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<Servicio> servicios =
            serviciosFromJson(jsonEncode(responseData["myServicio"]));
        _services = servicios;
        notifyListeners();
      } else {
        throw Exception('Failed to load services');
      }
    } catch (error) {
      throw Exception('Error fetching products: $error');
    }
  }

  Future<void> createServicio(Servicio servicio, List<Map<String, dynamic>> detalles) async {
    final url = Uri.parse('${Environment.apiUrl}/servicios/new');

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'nombre': servicio.nombre,
          'precio': servicio.precio,
          'detalles': detalles
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      await fetchServices();
    } catch (error) {
      throw Exception('Error creating product: $error');
    }
  }
}
