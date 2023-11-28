import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:salobe_app/global/environment.dart';
import 'package:salobe_app/models/cita_model.dart';
import 'dart:convert';

class CitaProvider extends ChangeNotifier {
  List<Cita> _citas = [];

  List<Cita> get citas => _citas;

  List<Cita> _allCitas = [];

  List<Cita> get allCitas => _allCitas;

  Future<void> fetchAllCitas() async {
    final url = Uri.parse('${Environment.apiUrl}/citas/all');
    try {
      final response =
          await http.get(url, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<Cita> allCitas =
            citasFromJson(jsonEncode(responseData["myCitas"]));
        _allCitas = allCitas;
        notifyListeners();
      } else {
        throw Exception('Failed to load all citas');
      }
    } catch (error) {
      throw Exception('Error fetching all citas: $error');
    }
  }

  Future<void> fetchCitas(String clienteId) async {
    final url = Uri.parse('${Environment.apiUrl}/citas');
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('GET', url);
      request.body = json.encode({"clienteId": clienteId});
      request.headers.addAll(headers);
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final responseData = jsonDecode(responseBody);
        final List<Cita> citas =
            citasFromJson(jsonEncode(responseData["myCitas"]));
        _citas = citas;
        notifyListeners();
      } else {
        throw Exception('Failed to load citas');
      }
    } catch (error) {
      throw Exception('Error fetching citas: $error');
    }
  }

  Future<void> createCita(
      Cita cita, List<Map<String, dynamic>> detalles) async {
    final url = Uri.parse('${Environment.apiUrl}/citas/new');

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'fechaHora': cita.fechahora,
          'trabajadoraId': cita.trabajadora,
          'clienteId': cita.cliente,
          'detalles': detalles
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      await fetchCitas(cita.cliente);
      await fetchAllCitas();
    } catch (error) {
      throw Exception('Error creating cita: $error');
    }
  }
}
