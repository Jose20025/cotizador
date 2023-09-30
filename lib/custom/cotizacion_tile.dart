import '../models/cotizacion.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CotizacionCard extends StatelessWidget {
  final Cotizacion cotizacion;
  const CotizacionCard({super.key, required this.cotizacion});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: ListTile(
              title: Center(
                  child: Text(
                      'Monto Total: ${NumberFormat.currency().format(cotizacion.montoTotal)}')),
              subtitle: Column(
                children: [
                  Text(
                      'Cuota: ${NumberFormat.currency().format(cotizacion.montoCuotas)}/mes'),
                  Text(
                      'Interés: ${NumberFormat.decimalPatternDigits().format(cotizacion.interes)}%'),
                  cotizacion.cuotaInicial == null
                      ? const SizedBox()
                      : Text(
                          'Cuota Inicial: ${NumberFormat.currency().format(cotizacion.cuotaInicial)}'),
                  Text(
                      'Tiempo: ${NumberFormat.decimalPatternDigits().format(cotizacion.tiempo)} ${cotizacion.tiempo > 1 ? "años" : "año"} | ${NumberFormat.decimalPatternDigits().format(cotizacion.tiempo * 12)} ${(cotizacion.tiempo * 24) > 1 ? "meses" : "mes"}'),
                ],
              )),
        ),
        const Divider()
      ],
    );
  }
}
