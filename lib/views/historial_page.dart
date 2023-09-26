import 'package:cotizador/custom/cotizacion_tile.dart';
import 'package:cotizador/models/cotizacion.dart';
import 'package:flutter/material.dart';

class HistorialPage extends StatelessWidget {
  final List<Cotizacion> cotizaciones;

  const HistorialPage({super.key, required this.cotizaciones});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Cotizaciones'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) =>
            CotizacionCard(cotizacion: cotizaciones[index]),
        itemCount: cotizaciones.length,
      ),
    );
  }
}
