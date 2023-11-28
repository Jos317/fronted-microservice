import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salobe_app/routes/routes.dart';
import 'package:salobe_app/services/Cita/cita_service.dart';
import 'package:salobe_app/services/Producto/producto_service.dart';
import 'package:salobe_app/services/Recibo/recibo_Service.dart';
import 'package:salobe_app/services/Servicio/servicio_service.dart';
import 'package:salobe_app/services/System/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
        ChangeNotifierProvider(create: (_) => CitaProvider()),
        ChangeNotifierProvider(create: (_) => ReciboProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SaloBe app',
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}
