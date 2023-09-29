import 'dart:math';
import 'package:cotizador/custom/custom_card.dart';
import 'package:cotizador/models/cotizacion.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

NumberFormat numberFormat = NumberFormat.decimalPattern('es_ES');

class CotizacionPage extends StatelessWidget {
  final double montoTotal;
  final double interes;
  final double tiempo;
  final double? cuotaInicial;

  const CotizacionPage({
    super.key,
    required this.montoTotal,
    required this.interes,
    required this.tiempo,
    this.cuotaInicial,
  });

  double obtenerCuotas(
      double montoTotal, double interes, double tiempo, double? cuotaInicial) {
    double interesMes = interes / 12;
    double tiempoMes = tiempo * 12;
    double montoCuotas;

    if (cuotaInicial != null) {
      montoTotal -= cuotaInicial;
    }

    montoCuotas =
        (montoTotal * interesMes) / ((1 - pow(1 + interesMes, -tiempoMes)));

    return montoCuotas;
  }

  @override
  Widget build(BuildContext context) {
    double? cuotas = obtenerCuotas(montoTotal, interes, tiempo, cuotaInicial);
    Cotizacion cotizacion = Cotizacion(
      interes: interes,
      cuotaInicial: cuotaInicial,
      montoTotal: montoTotal,
      cuotas: cuotas,
      tiempo: tiempo,
    );

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
                    '${numberFormat.format(cotizacion.tiempo)} ${cotizacion.tiempo > 1 ? "años" : "año"} | ${numberFormat.format(cotizacion.tiempo * 24)} ${(cotizacion.tiempo * 24) > 1 ? "meses" : "mes"}',
              ),
              CustomCard(
                icon: Icons.monetization_on_outlined,
                title: 'Cuotas al mes',
                subtitle: '${numberFormat.format(cotizacion.cuotas)} \$',
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
