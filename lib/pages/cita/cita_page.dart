import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salobe_app/models/cita_model.dart';
import 'package:salobe_app/pages/Home/menu.dart';
import 'package:salobe_app/pages/cita/cita_crear.dart';
import 'package:salobe_app/services/Cita/cita_service.dart';
import 'package:salobe_app/services/System/auth_service.dart';
import 'package:intl/intl.dart';

class CitaList extends StatefulWidget {
  const CitaList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CitaListState createState() => _CitaListState();
}

class _CitaListState extends State<CitaList> {
  @override
  void initState() {
    final authService = Provider.of<AuthService>(context, listen: false);
    final usuario = authService.usuario;
    Provider.of<CitaProvider>(context, listen: false).fetchCitas(usuario.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final citas = Provider.of<CitaProvider>(context).citas;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Citas'),
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CitaCrear()),
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: citas.length,
        itemBuilder: (BuildContext context, int index) {
          DateTime dateTimeUTC = DateTime.parse(citas[index].fechahora);
          DateTime localDateTime = dateTimeUTC.toLocal();
          String formattedLocalTime = DateFormat.yMMMMd('en_US').add_jms().format(localDateTime);
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text("Fecha y Hora: $formattedLocalTime"),
              trailing: const Text(
                "Empleado: Analia",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                _showProductDetails(citas[index]);
              },
            ),
          );
        },
      ),
    );
  }

  void _showProductDetails(Cita cita) {
    DateTime dateTimeUTC = DateTime.parse(cita.fechahora);
    DateTime localDateTime = dateTimeUTC.toLocal();
    String formattedLocalTime = DateFormat.yMMMMd('en_US').add_jms().format(localDateTime);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Fecha y Hora: $formattedLocalTime"),
          content: const Text("Empleado: Analia"),
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
