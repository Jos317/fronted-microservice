// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

Servicio servicioFromJson(String str) => Servicio.fromJson(json.decode(str));

List<Servicio> serviciosFromJson(String str) => List<Servicio>.from(json.decode(str).map((x) => Servicio.fromJson(x)));

class Servicio {
    Servicio({
        this.id,
        required this.nombre,
        required this.precio,
        this.v,
    });

    String? id;
    String nombre;
    double precio;
    int? v;

    factory Servicio.fromJson(Map<String, dynamic> json) => Servicio(
        id: json["_id"],
        nombre: json["nombre"],
        precio: json["precio"].toDouble(),
        v: json["__v"]
    );
}