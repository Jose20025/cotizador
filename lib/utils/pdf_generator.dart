import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';

import '../models/cotizacion.dart';
import 'package:pdf/widgets.dart' as pw;

class PDFGenerator {
  static Future<File> generatePDF(
      {required Cotizacion cotizacion, required String asesor}) async {
    final pageTheme = await getPageTheme();

    final logos = pw.MemoryImage(
      (await rootBundle.load('assets/images/logos_mana_cartagena.jpeg'))
          .buffer
          .asUint8List(),
    );

    final documentoPDF = pw.Document(
      title: 'Cotizacion para: ${cotizacion.referencia}',
      author: cotizacion.proyecto,
      subject: 'Cotizacion',
    );

    documentoPDF.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,

        //! HEADER
        header: (context) => pw.Container(
          width: double.infinity,
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Image(logos, width: 200),
              pw.Container(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'Oficina Central',
                      style: pw.TextStyle(
                          fontSize: 25, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 15),
                    pw.Text(
                      'Av. Banzer Calle 3 #3655',
                      style: const pw.TextStyle(fontSize: 13),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      'Teléfono: 76656551',
                      style: const pw.TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        //! BUILD
        build: (context) => [
          pw.SizedBox(height: 20),
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              borderRadius: pw.BorderRadius.circular(10),
              color: PdfColors.lightGreen,
            ),
            child: pw.Text(
              'COTIZACIÓN',
              style: pw.TextStyle(
                fontSize: 36,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
            ),
          ),
          pw.Divider(),
          pw.Container(
            padding: const pw.EdgeInsets.all(15),
            child: pw.Column(
              children: [
                pw.Container(
                  margin: const pw.EdgeInsets.only(left: 15, right: 15),
                  child: pw.Row(
                    children: [
                      pw.Text(
                        'Fecha: ',
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.SizedBox(width: 5),
                      pw.Text(
                          DateFormat("dd 'de' MMMM, yyyy")
                              .format(cotizacion.fecha!),
                          style: const pw.TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Container(
                  margin: const pw.EdgeInsets.only(left: 15, right: 15),
                  width: double.infinity,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Row(
                        children: [
                          pw.Text(
                            'Proyecto: ',
                            style: pw.TextStyle(
                                fontSize: 16, fontWeight: pw.FontWeight.bold),
                          ),
                          pw.SizedBox(width: 5),
                          pw.Text(
                            cotizacion.proyecto,
                            style: const pw.TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      pw.Row(
                        children: [
                          pw.Text(
                            'Cliente: ',
                            style: pw.TextStyle(
                                fontSize: 16, fontWeight: pw.FontWeight.bold),
                          ),
                          pw.SizedBox(width: 5),
                          pw.Text(
                            cotizacion.referencia,
                            style: const pw.TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          pw.Divider(),
          pw.Container(
            margin: const pw.EdgeInsets.only(left: 15),
            child: pw.Text(
              'Información del Lote',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18),
            ),
          ),
          pw.Divider(),
          pw.Container(
            padding: const pw.EdgeInsets.all(15),
            child: pw.Column(
              children: [
                pw.Container(
                  margin: const pw.EdgeInsets.only(left: 15, right: 35),
                  width: double.infinity,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Superficie',
                        style: const pw.TextStyle(fontSize: 16),
                      ),
                      pw.Text(
                        '${NumberFormat.decimalPatternDigits().format(cotizacion.superficie)} m²',
                        style: const pw.TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Container(
                  margin: const pw.EdgeInsets.only(left: 15, right: 35),
                  width: double.infinity,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Precio del Lote',
                        style: const pw.TextStyle(fontSize: 16),
                      ),
                      pw.Text(
                        NumberFormat.currency().format(cotizacion.montoTotal),
                        style: const pw.TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          pw.Divider(),
          pw.Container(
            margin: const pw.EdgeInsets.only(left: 15),
            child: pw.Text(
              'Plan de Pago',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18),
            ),
          ),
          pw.Divider(),
          pw.SizedBox(height: 15),
          pw.Container(
            margin: const pw.EdgeInsets.only(left: 30, right: 20),
            width: double.infinity,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Tiempo',
                  style: const pw.TextStyle(fontSize: 16),
                ),
                pw.Text(
                  '${NumberFormat.decimalPatternDigits().format(cotizacion.tiempo / 12)} ${(cotizacion.tiempo / 12) > 1 ? "años" : "año"} | ${NumberFormat.decimalPatternDigits().format(cotizacion.tiempo)} ${(cotizacion.tiempo) > 1 ? "meses" : "mes"}',
                  style: const pw.TextStyle(fontSize: 16),
                )
              ],
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Container(
            margin: const pw.EdgeInsets.only(left: 30, right: 20),
            width: double.infinity,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Cuota Inicial',
                  style: const pw.TextStyle(fontSize: 16),
                ),
                pw.Text(
                  NumberFormat.currency().format(cotizacion.cuotaInicial),
                  style: const pw.TextStyle(fontSize: 16),
                )
              ],
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Container(
            margin: const pw.EdgeInsets.only(left: 30, right: 20),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Monto sin Cuota Inicial',
                  style: const pw.TextStyle(fontSize: 16),
                ),
                pw.Text(
                  NumberFormat.currency()
                      .format(cotizacion.montoTotal! - cotizacion.cuotaInicial),
                  style: const pw.TextStyle(fontSize: 16),
                )
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Row(
            children: [
              pw.Spacer(flex: 3),
              pw.Expanded(
                flex: 7,
                child: pw.Divider(),
              )
            ],
          ),
          pw.SizedBox(height: 15),
          pw.Row(
            children: [
              pw.Spacer(flex: 4),
              pw.Expanded(
                flex: 6,
                child: pw.Container(
                  margin: const pw.EdgeInsets.symmetric(horizontal: 15),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Cuotas Mensuales',
                        style: const pw.TextStyle(fontSize: 16),
                      ),
                      pw.Text(
                        NumberFormat.currency()
                            .format(cotizacion.importeCuotas),
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );

    final dir = await getTemporaryDirectory();

    final archivo = File('${dir.path}/cotizacion-${cotizacion.referencia}.pdf');

    await archivo.writeAsBytes(await documentoPDF.save());

    return archivo;
  }

  static Future<pw.PageTheme> getPageTheme() async {
    final ttfLight = pw.Font.ttf(
        await rootBundle.load('assets/fonts/poppins/Poppins-Light.ttf'));
    final ttfBold = pw.Font.ttf(
        await rootBundle.load('assets/fonts/poppins/Poppins-SemiBold.ttf'));

    final logos = pw.MemoryImage(
      (await rootBundle.load('assets/images/logos_mana_cartagena.jpeg'))
          .buffer
          .asUint8List(),
    );

    return pw.PageTheme(
      margin: const pw.EdgeInsets.only(
          top: 2 * PdfPageFormat.cm,
          left: 2 * PdfPageFormat.cm,
          right: 2 * PdfPageFormat.cm,
          bottom: 1 * PdfPageFormat.cm),
      textDirection: pw.TextDirection.ltr,
      orientation: pw.PageOrientation.portrait,
      theme: pw.ThemeData(
          defaultTextStyle: pw.TextStyle(font: ttfLight, fontBold: ttfBold)),
      buildBackground: (context) => pw.FullPage(
        ignoreMargins: false,
        child: pw.Watermark(
          child: pw.Opacity(
            opacity: 0.1,
            child: pw.Image(
              logos,
              // alignment: pw.Alignment.center,
              // fit: pw.BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  static pw.Column crearDivisor() {
    return pw.Column(
      children: [
        pw.SizedBox(height: 5),
        pw.Divider(),
        pw.SizedBox(height: 5),
      ],
    );
  }
}
