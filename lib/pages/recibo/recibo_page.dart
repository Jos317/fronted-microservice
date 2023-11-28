import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salobe_app/models/recibo_model.dart';
import 'package:salobe_app/pages/Home/menu.dart';
import 'package:salobe_app/pages/recibo/recibo_crear.dart';
import 'package:salobe_app/services/Recibo/recibo_Service.dart';
import 'package:salobe_app/services/System/auth_service.dart';
import 'package:intl/intl.dart';

class ReciboList extends StatefulWidget {
  const ReciboList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReciboListState createState() => _ReciboListState();
}

class _ReciboListState extends State<ReciboList> {
  @override
  void initState() {
    final authService = Provider.of<AuthService>(context, listen: false);
    final usuario = authService.usuario;
    Provider.of<ReciboProvider>(context, listen: false)
        .fetchRecibos(usuario.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final recibos = Provider.of<ReciboProvider>(context).recibos;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Recibos'),
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReciboCrear()),
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: recibos.length,
        itemBuilder: (BuildContext context, int index) {
          DateTime dateTimeUTC = DateTime.parse(recibos[index].fecha);
          DateTime localDateTime = dateTimeUTC.toLocal();
          String formattedLocalTime =
              DateFormat.yMMMMd('en_US').add_jms().format(localDateTime);
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text("Fecha y Hora: $formattedLocalTime"),
              trailing: const Text(
                "Cliente: Thania Ferrufino",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                _showReciboDetails(recibos[index]);
              },
            ),
          );
        },
      ),
    );
  }

  void _showReciboDetails(Recibo recibo) {
    DateTime dateTimeUTC = DateTime.parse(recibo.fecha);
    DateTime localDateTime = dateTimeUTC.toLocal();
    String formattedLocalTime =
        DateFormat.yMMMMd('en_US').add_jms().format(localDateTime);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Fecha y Hora: $formattedLocalTime de la cita\n${recibo.total.toString()} Bs de la cita"),
          content: const Text("Cliente: Thania Ferrufino"),
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
