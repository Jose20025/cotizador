import 'package:cotizador/custom/custom_card.dart';
import 'package:cotizador/models/cotizacion.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

NumberFormat numberFormat = NumberFormat.decimalPattern('es_ES');

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
                subtitle: '${numberFormat.format(cotizacion.montoTotal)} \$',
                icon: Icons.monetization_on_outlined,
              ),
              cotizacion.cuotaInicial != null
                  ? CustomCard(
                      title: 'Cuota Inicial',
                      subtitle:
                          '${numberFormat.format(cotizacion.cuotaInicial)} \$',
                      icon: Icons.monetization_on_outlined)
                  : const SizedBox(),
              CustomCard(
                icon: Icons.access_alarm_outlined,
                title: 'Tiempo',
                subtitle:
                    '${numberFormat.format(cotizacion.tiempo)} ${cotizacion.tiempo > 1 ? "años" : "año"} | ${numberFormat.format(cotizacion.tiempo * 12)} ${(cotizacion.tiempo * 24) > 1 ? "meses" : "mes"}',
              ),
              CustomCard(
                icon: Icons.monetization_on_outlined,
                title: 'Cuotas al mes',
                subtitle: '${numberFormat.format(cotizacion.montoCuotas)} \$',
              ),
              CustomCard(
                icon: Icons.percent,
                title: 'Tasa de Interes',
                subtitle:
                    '${numberFormat.format(cotizacion.interes * 100)}% Anual | ${numberFormat.format(cotizacion.interes * 100 / 12)}% Mensual',
              )
            ],
          ),
        ),
      ),
    );
  }
}
