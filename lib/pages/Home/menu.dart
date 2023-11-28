import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salobe_app/pages/cita/cita_page.dart';
import 'package:salobe_app/pages/product/producto_page.dart';
import 'package:salobe_app/pages/recibo/recibo_page.dart';
import 'package:salobe_app/pages/servicio/servicio_page.dart';
import 'package:salobe_app/services/System/auth_service.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final usuario = authService.usuario;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          usuario.rol != "Cliente"
          ? ListTile(
            title: const Text('Productos'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductList()),
              );
            },
          )
          : Container(),
          usuario.rol != "Cliente"
          ? ListTile(
            title: const Text('Recibos'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReciboList()),
              );
            },
          )
          : Container(),
          usuario.rol != "Cliente"
          ? ListTile(
            title: const Text('Servicios'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ServiceList()),
              );
            },
          )
          : ListTile(
            title: const Text('Citas'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CitaList()),
              );
            },
          ),
          ListTile(
            title: const Text('Salir'),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'login');
              AuthService.deleteToken();
            },
          ),
        ],
      ),
    );
  }
}