import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../custom/custom_card.dart';
import '../models/cotizacion.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;

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
            final cotizacionPDF = pw.Document(
              title: 'Cotizacion para: ${cotizacion.referencia}',
            );

            cotizacionPDF.addPage(
              pw.MultiPage(
                header: (context) => pw.Column(
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Container(
                          child: pw.Center(
                            child: pw.Text(
                              'Cotización',
                              style: pw.TextStyle(
                                fontSize: 24,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            DateFormat("EEEE, dd 'de' MMMM 'de' yyyy")
                                .format(cotizacion.fecha!),
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    pw.Divider(),
                  ],
                ),
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                build: (context) => [
                  pw.SizedBox(height: 60),
                  pw.Text(
                    'Cliente - ${cotizacion.referencia}',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Row(
                    children: [
                      pw.Spacer(flex: 2),
                      pw.Expanded(
                        flex: 5,
                        child: pw.Divider(),
                      ),
                      pw.Spacer(flex: 2),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(20),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(),
                      borderRadius: pw.BorderRadius.circular(10),
                    ),
                    width: 300,
                    child: pw.Column(children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                        children: [
                          pw.Text('Superficie del Lote',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 16)),
                          pw.SizedBox(width: 50),
                          pw.Text(
                              '${NumberFormat.decimalPatternDigits().format(cotizacion.superficie)} m²',
                              style: const pw.TextStyle(fontSize: 16)),
                        ],
                      ),
                      crearDivisor(),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                        children: [
                          pw.Text('Precio por m²',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 16)),
                          pw.SizedBox(width: 70),
                          pw.Text(
                              NumberFormat.currency()
                                  .format(cotizacion.precioMetroCuadrado),
                              style: const pw.TextStyle(fontSize: 16)),
                        ],
                      ),
                      crearDivisor(),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                        children: [
                          pw.Text('Monto total',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 16)),
                          pw.SizedBox(width: 70),
                          pw.Text(
                              NumberFormat.currency()
                                  .format(cotizacion.montoPagar),
                              style: const pw.TextStyle(fontSize: 16)),
                        ],
                      ),
                      cotizacion.cuotaInicial == null
                          ? pw.SizedBox()
                          : pw.Column(children: [
                              crearDivisor(),
                              pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceEvenly,
                                children: [
                                  pw.Text('Cuota Inicial',
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 16)),
                                  pw.SizedBox(width: 60),
                                  pw.Text(
                                      NumberFormat.currency()
                                          .format(cotizacion.cuotaInicial),
                                      style: const pw.TextStyle(fontSize: 16)),
                                ],
                              ),
                            ]),
                      crearDivisor(),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                        children: [
                          pw.Text('Tiempo',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 16)),
                          pw.SizedBox(width: 40),
                          pw.Text(
                              '${NumberFormat.decimalPatternDigits().format(cotizacion.tiempo / 12)} ${(cotizacion.tiempo / 12) > 1 ? "años" : "año"} | ${NumberFormat.decimalPatternDigits().format(cotizacion.tiempo)} ${(cotizacion.tiempo) > 1 ? "meses" : "mes"}',
                              style: const pw.TextStyle(fontSize: 16)),
                        ],
                      ),
                      crearDivisor(),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                        children: [
                          pw.Text('Importe de Cuotas',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 16)),
                          pw.SizedBox(width: 30),
                          pw.Text(
                            NumberFormat.currency()
                                .format(cotizacion.importeCuotas),
                            style: const pw.TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ]),
                  ),
                  crearDivisor(),
                ],
              ),
            );

            final dir = await getTemporaryDirectory();

            final archivo =
                File('${dir.path}/cotizacion-${cotizacion.referencia}.pdf');

            await archivo.writeAsBytes(await cotizacionPDF.save());

            await OpenFile.open(
                '${dir.path}/cotizacion-${cotizacion.referencia}.pdf');
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

  pw.SizedBox crearDivisor() {
    return pw.SizedBox(height: 15);
  }
}
