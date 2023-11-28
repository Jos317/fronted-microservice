// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

Producto productoFromJson(String str) => Producto.fromJson(json.decode(str));

List<Producto> productosFromJson(String str) => List<Producto>.from(json.decode(str).map((x) => Producto.fromJson(x)));

class Producto {
    Producto({
        this.id,
        required this.nombre,
        required this.cantidad,
        required this.precio,
        this.v,
    });

    String? id;
    String nombre;
    int cantidad;
    double precio;
    int? v;

    factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        id: json["_id"],
        nombre: json["nombre"],
        cantidad: json["cantidad"],
        precio: json["precio"].toDouble(),
        v: json["__v"]
    );
}