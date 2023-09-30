import 'dart:convert';

import '../custom/input_form.dart';
import '../models/cotizacion.dart';
import 'cotizacion_page.dart';
import 'historial_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Cotizacion> cotizaciones = [];

  @override
  void initState() {
    super.initState();
    obtenerCotizaciones();
  }

  @override
  void dispose() {
    super.dispose();
    guardarCotizaciones();
    cotizaciones = [];
  }

  void obtenerCotizaciones() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final cotizacionesJson = prefs.getString('historial');

    if (cotizacionesJson == null) return;

    final List<dynamic> jsonList = json.decode(cotizacionesJson);

    for (var elemento in jsonList) {
      cotizaciones.add(Cotizacion.fromJson(elemento));
    }
  }

  void guardarCotizaciones() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final cotizacionesJson = json.encode(cotizaciones);

    await prefs.setString('historial', cotizacionesJson);
  }

  void cotizar(Cotizacion cotizacion) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CotizacionPage(cotizacion: cotizacion),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double? precioMetroCuadrado;
  double? superficie;
  double? cuotaInicial;
  int? tiempo;

  Cotizacion crearCotizacion(double precioMetroCuadrado, double superficie,
      double? cuotaInicial, int tiempo) {
    final montoTotal = superficie * precioMetroCuadrado;

    final montoTotalSinInicial =
        cuotaInicial != null ? (montoTotal - cuotaInicial) : null;

    final mantenimiento = cuotaInicial != null
        ? obtenerMontoMantenimiento(montoTotalSinInicial!)
        : obtenerMontoMantenimiento(montoTotal);

    final montoPagar = cuotaInicial != null
        ? (montoTotalSinInicial! + mantenimiento)
        : (montoTotal + mantenimiento);

    final importeCuotas = montoPagar / tiempo;

    return Cotizacion(
      superficie: superficie,
      precioMetroCuadrado: precioMetroCuadrado,
      tiempo: tiempo,
      cuotaInicial: cuotaInicial,
      importeCuotas: importeCuotas,
      mantenimiento: mantenimiento,
      montoPagar: montoPagar,
      montoTotal: montoTotal,
    );
  }

  double obtenerMontoMantenimiento(double monto) {
    return monto * 8 / 100 * 10;
  }

  void buttonPress() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistorialPage(
          cotizaciones: cotizaciones,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Cotizador de Cuotas'),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const Divider(),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              width: 300,
              child: ElevatedButton(
                onPressed: buttonPress,
                child: const Text(
                  'Historial de Cotizaciones',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 25),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InputForm(
                        validate: true,
                        width: 150,
                        label: 'Precio de m²',
                        type: TextInputType.number,
                        onSave: (value) {
                          precioMetroCuadrado = double.parse(value!);
                        },
                      ),
                      InputForm(
                        validate: true,
                        width: 180,
                        label: 'Superficie de Lote (m²)',
                        type: TextInputType.number,
                        onSave: (value) {
                          superficie = double.parse(value!);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const SizedBox(width: 20),
                      InputForm(
                        validate: false,
                        width: 150,
                        label: 'Cuota Inicial',
                        type: TextInputType.number,
                        onSave: (value) {
                          cuotaInicial =
                              value != null ? double.parse(value) : null;
                        },
                      ),
                      const SizedBox(width: 38),
                      InputForm(
                        validate: true,
                        width: 150,
                        label: 'Tiempo (meses)',
                        type: TextInputType.number,
                        onSave: (value) {
                          tiempo = int.parse(value!);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 50,
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _formKey.currentState!.reset();
                          FocusScope.of(context).unfocus();

                          final cotizacion = crearCotizacion(
                            precioMetroCuadrado!,
                            superficie!,
                            cuotaInicial,
                            tiempo!,
                          );

                          cotizar(cotizacion);
                        }
                      },
                      child: const Text(
                        'Cotizar',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
