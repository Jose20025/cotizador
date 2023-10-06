import '../custom/cotizacion_tile.dart';
import '../models/cotizacion.dart';
import 'package:flutter/material.dart';

class HistorialPage extends StatefulWidget {
  final List<Cotizacion> cotizaciones;
  final Function eliminarHistorial;

  const HistorialPage(
      {super.key, required this.cotizaciones, required this.eliminarHistorial});

  @override
  State<HistorialPage> createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  Future<void> eliminarHistorial() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: const Text('¿Estás seguro de borrar el historial?'),
        title: const Text("Confirmación"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                widget.eliminarHistorial();
                widget.cotizaciones.clear();
                Navigator.of(context).pop();
              });
            },
            child: const Text("Si"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Cotizaciones'),
        leading: const BackButton(),
        actions: [
          IconButton(
            onPressed: () async {
              await eliminarHistorial();
            },
            icon: const Icon(Icons.delete_forever),
          )
        ],
      ),
      body: widget.cotizaciones.isNotEmpty
          ? ListView.separated(
              itemBuilder: (context, index) =>
                  CotizacionCard(cotizacion: widget.cotizaciones[index]),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: widget.cotizaciones.length,
            )
          : Container(
              margin: const EdgeInsets.all(10),
              child: const Center(
                child: Text(
                  'No hay cotizaciones guardadas aun',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
              ),
            ),
    );
  }
}
