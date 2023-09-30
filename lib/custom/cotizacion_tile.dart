import '../models/cotizacion.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CotizacionCard extends StatelessWidget {
  final Cotizacion cotizacion;
  const CotizacionCard({super.key, required this.cotizacion});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Card(
            child: ListTile(
                title: Center(
                    child: Text(
                        'Import de Cuotas: ${NumberFormat.currency().format(cotizacion.importeCuotas)}/mes')),
                subtitle: Column(
                  children: [
                    Text(
                        'Monto a Pagar: ${NumberFormat.currency().format(cotizacion.montoPagar)}'),
                    Text(
                        'Superficie del Lote: ${NumberFormat.decimalPatternDigits().format(cotizacion.superficie)} m²'),
                    Text(
                        'Mantenimiento: ${NumberFormat.currency().format(cotizacion.mantenimiento)}'),
                    Text(
                        'Precio por m²: ${NumberFormat.currency().format(cotizacion.precioMetroCuadrado)}'),
                    cotizacion.cuotaInicial == null
                        ? const SizedBox()
                        : Text(
                            'Cuota Inicial: ${NumberFormat.currency().format(cotizacion.cuotaInicial)}'),
                    Text(
                        'Tiempo: ${NumberFormat.decimalPatternDigits().format(cotizacion.tiempo)} ${cotizacion.tiempo > 1 ? "meses" : "mes"} | ${NumberFormat.decimalPatternDigits().format(cotizacion.tiempo / 12)} ${(cotizacion.tiempo / 12) > 1 ? "años" : "año"}'),
                  ],
                )),
          ),
          const Divider()
        ],
      ),
    );
  }
}
