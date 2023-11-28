// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

List<Usuario> usuariosFromJson(String str) => List<Usuario>.from(json.decode(str).map((x) => Usuario.fromJson(x)));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
  Usuario({
    required this.ci,
    required this.nombre,
    required this.email,
    required this.uid,
    required this.rol,
  });

  String ci;
  String nombre;
  String email;
  String uid;
  String rol;

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        ci: json["ci"],
        nombre: json["nombre"],
        email: json["email"],
        uid: json["uid"],
        rol: json["rol"],
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "email": email,
        "uid": uid,
        "rol": rol,
      };
}
