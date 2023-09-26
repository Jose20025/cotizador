import 'package:cotizador/models/cotizacion.dart';
import 'package:flutter/material.dart';

class CotizacionCard extends StatelessWidget {
  final Cotizacion cotizacion;
  const CotizacionCard({super.key, required this.cotizacion});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: ListTile(
            title: Text(cotizacion.montoTotal.toString()),
            subtitle: Text('Cuotas: \$${cotizacion.cuotas}/año'),
          ),
        ),
        const Divider()
      ],
    );
  }
}
