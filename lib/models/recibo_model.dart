// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

Recibo reciboFromJson(String str) => Recibo.fromJson(json.decode(str));

List<Recibo> recibosFromJson(String str) =>
    List<Recibo>.from(json.decode(str).map((x) => Recibo.fromJson(x)));

class Recibo {
  Recibo({
    this.id,
    required this.fecha,
    required this.total,
    required this.trabajadora,
    required this.cliente,
    required this.cita,
    this.v,
  });

  String? id;
  String fecha;
  double total;
  String trabajadora;
  String cliente;
  String cita;
  int? v;

  factory Recibo.fromJson(Map<String, dynamic> json) => Recibo(
      id: json["_id"],
      fecha: json["fecha"],
      total: json["total"].toDouble(),
      trabajadora: json["trabajadora"],
      cliente: json["cliente"],
      cita: json["cita"],
      v: json["__v"]);
}
