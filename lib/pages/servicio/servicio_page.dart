import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salobe_app/models/servicio_model.dart';
import 'package:salobe_app/pages/Home/menu.dart';
import 'package:salobe_app/pages/cita/cita_crear.dart';
import 'package:salobe_app/pages/product/producto_crear.dart';
import 'package:salobe_app/pages/servicio/servicio_crear.dart';
import 'package:salobe_app/services/Servicio/servicio_service.dart';

class ServiceList extends StatefulWidget {
  const ServiceList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ServiceListState createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList> {
  @override
  void initState() {
    Provider.of<ServiceProvider>(context, listen: false).fetchServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final servicios = Provider.of<ServiceProvider>(context).services;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Servicios'),
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ServicioCrear()),
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: servicios.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(servicios[index].nombre),
              trailing: Text(
                "${servicios[index].precio.toString()} Bs",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                _showProductDetails(servicios[index]);
              },
            ),
          );
        },
      ),
    );
  }

  void _showProductDetails(Servicio servicio) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(servicio.nombre),
          content: Text(
              'Precio: ${servicio.precio} Bs'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
