import 'package:cotizador/models/cotizacion.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

NumberFormat numberFormat = NumberFormat.decimalPattern('es_ES');

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
                  child: Text('Monto Total: ${cotizacion.montoTotal}\$')),
              subtitle: Column(
                children: [
                  Text(
                      'Cuota: ${numberFormat.format(cotizacion.montoCuotas)}\$/mes'),
                  Text(
                      'Interés: ${numberFormat.format(cotizacion.interes * 100)}%'),
                  cotizacion.cuotaInicial == null
                      ? const SizedBox()
                      : Text(
                          'Cuota Inicial: ${numberFormat.format(cotizacion.cuotaInicial)}\$'),
                  Text(
                      'Tiempo: ${numberFormat.format(cotizacion.tiempo)} ${cotizacion.tiempo > 1 ? "años" : "año"} | ${numberFormat.format(cotizacion.tiempo * 12)} ${(cotizacion.tiempo * 24) > 1 ? "meses" : "mes"}'),
                ],
              )),
        ),
        const Divider()
      ],
    );
  }
}
