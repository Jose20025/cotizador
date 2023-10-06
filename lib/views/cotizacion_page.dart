import 'package:open_file/open_file.dart';

import '../custom/custom_card.dart';
import '../models/cotizacion.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/pdf_generator.dart';

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
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final archivo =
                await PDFGenerator.generatePDF(cotizacion: cotizacion);

            await OpenFile.open(archivo.path);
          },
          tooltip: 'Exportar como PDF',
          label: const Text(
            'Exportar PDF',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          elevation: 5,
          enableFeedback: true,
          icon: const Icon(Icons.picture_as_pdf)),
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
                subtitle: NumberFormat.currency().format(cotizacion.montoPagar),
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
                    '${NumberFormat.decimalPatternDigits().format(cotizacion.tiempo / 12)} ${(cotizacion.tiempo / 12) > 1 ? "años" : "año"} | ${NumberFormat.decimalPatternDigits().format(cotizacion.tiempo)} ${(cotizacion.tiempo) > 1 ? "meses" : "mes"}',
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
