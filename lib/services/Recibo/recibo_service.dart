import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:salobe_app/global/environment.dart';
import 'dart:convert';

import 'package:salobe_app/models/recibo_model.dart';


class ReciboProvider extends ChangeNotifier {
  List<Recibo> _recibos = [];

  List<Recibo> get recibos => _recibos;

  Future<void> fetchRecibos(String trabajadoraId) async {
    final url = Uri.parse('${Environment.apiUrl}/recibos');
    try {
      var headers = {
        'Content-Type': 'application/json'
      };
      var request = http.Request('GET', url);
      request.body = json.encode({
        "trabajadoraId": trabajadoraId
      });
      request.headers.addAll(headers);
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final responseData = json.decode(responseBody);
        final List<Recibo> recibos =
            recibosFromJson(jsonEncode(responseData["myRecibos"]));
        _recibos = recibos;
        notifyListeners();
      } else {
        throw Exception('Failed to load recibos');
      }
    } catch (error) {
      throw Exception('Error fetching recibos: $error');
    }
  }

  Future<void> createRecibo(Recibo recibo, List<Map<String, dynamic>> detalles) async {
    final url = Uri.parse('${Environment.apiUrl}/recibos/new');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'fecha': recibo.fecha,
          'total': recibo.total,
          'trabajadoraId': recibo.trabajadora,
          'clienteId': recibo.cliente,
          'citas': recibo.cita, 
          'detalles': detalles
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      await fetchRecibos(recibo.trabajadora);
    } catch (error) {
      throw Exception('Error creating recibos: $error');
    }
  }
}
