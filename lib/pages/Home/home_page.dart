import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salobe_app/pages/Home/menu.dart';
import 'package:salobe_app/services/System/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final usuario = authService.usuario;
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Information'),
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Name:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    usuario.nombre,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'CI:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    usuario.ci,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Email:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    usuario.email,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Rol:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    usuario.rol,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
