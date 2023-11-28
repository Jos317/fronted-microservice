import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:salobe_app/global/environment.dart';
import 'package:salobe_app/models/login_model.dart';
import 'package:salobe_app/models/usuario_model.dart';

class AuthService with ChangeNotifier {
  late Usuario usuario;
  bool _autenticando = false;

  List<Usuario> _usuarios = [];

  List<Usuario> get usuarios => _usuarios;

  List<Usuario> _clientes = [];

  List<Usuario> get clientes => _clientes;

  Future<void> fetchusuarios() async {
    final url = Uri.parse('${Environment.apiUrl}/usuarios');
    try {
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<Usuario> usuarios =
            usuariosFromJson(jsonEncode(responseData["usuarios"]));
        _usuarios = usuarios;
        notifyListeners();
      } else {
        throw Exception('Failed to load usuarios');
      }
    } catch (error) {
      throw Exception('Error fetching usuarios: $error');
    }
  }

  Future<void> fetchClientes() async {
    final url = Uri.parse('${Environment.apiUrl}/usuarios/clientes');
    try {
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<Usuario> clientes =
            usuariosFromJson(jsonEncode(responseData["usuarios"]));
        _clientes = clientes;
        notifyListeners();
      } else {
        throw Exception('Failed to load clientes');
      }
    } catch (error) {
      throw Exception('Error fetching clientes: $error');
    }
  }

  // Create Storage
  final _storage = new FlutterSecureStorage();

  bool get autenticando => _autenticando;
  set autenticando(bool valor) {
    _autenticando = valor;
    notifyListeners();
  }

  // Getters del token de forma estática
  static Future<String?> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    this.autenticando = true;

    final data = {'email': email, 'password': password};
    final uri = Uri.parse('${Environment.apiUrl}/login');

    final resp = await http.post(
      uri,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    this.autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;

      await this._saveToken(loginResponse.token);

      return true;
    } else {
      return false;
    }
  }

  Future register(String name, String email, String password) async {
    this.autenticando = true;

    final data = {'nombre': name, 'email': email, 'password': password};

    final uri = Uri.parse('${Environment.apiUrl}/login/new');

    final resp = await http.post(
      uri,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    this.autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;

      await this._saveToken(loginResponse.token);

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');

    final uri = Uri.parse('${Environment.apiUrl}/login/renew');

    final resp;

    if (token != null) {
      resp = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );
    } else {
      resp = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );
    }

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;

      await _saveToken(loginResponse.token);

      return true;
    } else {
      logout();
      return false;
    }
  }

  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}
