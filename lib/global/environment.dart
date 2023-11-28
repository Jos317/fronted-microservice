import 'dart:io';

class Environment {
  static String apiUrl = Platform.isAndroid ? 'https://salobeappmicroservicios.up.railway.app/api' : 'http://localhost:3001/api';
}