import '../custom/custom_card.dart';
import '../models/cotizacion.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CotizacionAsesorPage extends StatelessWidget {
  final Cotizacion cotizacion;

  const CotizacionAsesorPage({super.key, required this.cotizacion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cotización para Asesor'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              CustomCard(
                title: 'Superficie del Lote',
                subtitle:
                    '${NumberFormat.decimalPatternDigits().format(cotizacion.superficie)} m²',
                icon: Icons.monetization_on_outlined,
              ),
              CustomCard(
                icon: Icons.monetization_on_outlined,
                title: 'Precio por m²',
                subtitle: NumberFormat.currency()
                    .format(cotizacion.precioMetroCuadrado),
              ),
              CustomCard(
                title: 'Monto Total',
                subtitle: NumberFormat.currency().format(cotizacion.montoTotal),
                icon: Icons.monetization_on_outlined,
              ),
              cotizacion.cuotaInicial != null
                  ? CustomCard(
                      title: 'Cuota Inicial',
                      subtitle: NumberFormat.currency()
                          .format(cotizacion.cuotaInicial),
                      icon: Icons.monetization_on_outlined)
                  : const SizedBox(),
              CustomCard(
                icon: Icons.monetization_on_outlined,
                title: 'Monto a Pagar',
                subtitle: NumberFormat.currency().format(cotizacion.montoPagar),
              ),
              CustomCard(
                icon: Icons.access_alarm_outlined,
                title: 'Tiempo',
                subtitle:
                    '${NumberFormat.decimalPatternDigits().format(cotizacion.tiempo / 12)} ${cotizacion.tiempo > 1 ? "años" : "año"} | ${NumberFormat.decimalPatternDigits().format(cotizacion.tiempo)} ${(cotizacion.tiempo * 24) > 1 ? "meses" : "mes"}',
              ),
              CustomCard(
                title: 'Mantenimiento',
                subtitle:
                    NumberFormat.currency().format(cotizacion.mantenimiento),
                icon: Icons.monetization_on_outlined,
              ),
              CustomCard(
                icon: Icons.monetization_on_outlined,
                title: 'Importe de Cuota',
                subtitle:
                    NumberFormat.currency().format(cotizacion.importeCuotas),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
