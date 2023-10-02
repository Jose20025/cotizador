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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Cotizaciones'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await widget.eliminarHistorial();
              setState(() {
                widget.cotizaciones.clear();
              });
            },
            icon: const Icon(Icons.delete_forever),
          )
        ],
      ),
      body: widget.cotizaciones.isNotEmpty
          ? ListView.builder(
              itemBuilder: (context, index) =>
                  CotizacionCard(cotizacion: widget.cotizaciones[index]),
              itemCount: widget.cotizaciones.length,
            )
          : const Center(
              child: Text(
                'No hay cotizaciones guardadas aun',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }
}
