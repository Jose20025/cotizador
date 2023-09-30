import '../custom/custom_card.dart';
import '../models/cotizacion.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CotizacionPage extends StatelessWidget {
  final Cotizacion cotizacion;

  const CotizacionPage({super.key, required this.cotizacion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cotización'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
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
                icon: Icons.access_alarm_outlined,
                title: 'Tiempo',
                subtitle:
                    '${NumberFormat.decimalPatternDigits().format(cotizacion.tiempo)} ${cotizacion.tiempo > 1 ? "años" : "año"} | ${NumberFormat.decimalPatternDigits().format(cotizacion.tiempo * 12)} ${(cotizacion.tiempo * 24) > 1 ? "meses" : "mes"}',
              ),
              CustomCard(
                icon: Icons.monetization_on_outlined,
                title: 'Importe de Cuota',
                subtitle:
                    NumberFormat.currency().format(cotizacion.montoCuotas),
              ),
              CustomCard(
                icon: Icons.percent,
                title: 'Tasa de Interes',
                subtitle:
                    '${NumberFormat.decimalPatternDigits().format(cotizacion.interes * 100)}% Anual | ${NumberFormat.decimalPatternDigits().format(cotizacion.interes * 100 / 12)}% Mensual',
              )
            ],
          ),
        ),
      ),
    );
  }
}
