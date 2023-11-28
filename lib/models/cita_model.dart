// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

Cita citaFromJson(String str) => Cita.fromJson(json.decode(str));

List<Cita> citasFromJson(String str) =>
    List<Cita>.from(json.decode(str).map((x) => Cita.fromJson(x)));

class Cita {
  Cita({
    this.id,
    required this.fechahora,
    required this.trabajadora,
    required this.cliente,
    this.v,
  });

  String? id;
  String fechahora;
  String trabajadora;
  String cliente;
  int? v;

  factory Cita.fromJson(Map<String, dynamic> json) => Cita(
      id: json["_id"],
      fechahora: json["fechaHora"],
      trabajadora: json["trabajadora"],
      cliente: json["cliente"],
      v: json["__v"]);
}
