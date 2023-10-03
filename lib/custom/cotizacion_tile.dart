import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/cotizacion.dart';
import 'mini_card.dart';

class CotizacionCard extends StatelessWidget {
  final Cotizacion cotizacion;

  const CotizacionCard({super.key, required this.cotizacion});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Card(
          elevation: 4,
          child: ListTile(
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                            child: Text(
                          DateFormat('dd/MMM/yyyy').format(cotizacion.fecha!),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Center(
                  child: Text(
                    'Cotización para:\t\t\t\t\t\t ${cotizacion.referencia}',
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            subtitle: Column(
              children: [
                const Divider(),
                MiniCard(
                    title: 'Importe de Cuotas',
                    subtitle: NumberFormat.currency()
                        .format(cotizacion.importeCuotas)),
                MiniCard(
                    title: 'Monto a Pagar',
                    subtitle:
                        NumberFormat.currency().format(cotizacion.montoPagar)),
                MiniCard(
                    title: 'Mantenimiento',
                    subtitle: NumberFormat.currency()
                        .format(cotizacion.mantenimiento)),
                MiniCard(
                  title: 'Tiempo',
                  subtitle:
                      '${NumberFormat.decimalPatternDigits().format(cotizacion.tiempo / 12)} ${(cotizacion.tiempo / 12) == 1 ? "año" : "años"} | ${NumberFormat.decimalPatternDigits().format(cotizacion.tiempo)} ${(cotizacion.tiempo) == 1 ? "mes" : "meses"}',
                ),
                MiniCard(
                  title: 'Superficie del Lote',
                  subtitle:
                      NumberFormat.currency().format(cotizacion.superficie),
                ),
                MiniCard(
                  title: 'Precio del m²',
                  subtitle: NumberFormat.currency()
                      .format(cotizacion.precioMetroCuadrado),
                ),
              ],
            ),
          ),
        ));
  }
}
