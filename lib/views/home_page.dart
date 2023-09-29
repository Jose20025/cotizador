import 'dart:convert';
import 'dart:math';

import 'package:cotizador/custom/borrar_historial_boton.dart';
import 'package:cotizador/custom/input_form.dart';
import 'package:cotizador/models/cotizacion.dart';
import 'package:cotizador/views/cotizacion_page.dart';
import 'package:cotizador/views/historial_page.dart';
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double? montoTotal;
  double? interes;
  double? cuotaInicial;
  double? tiempo;

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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InputForm(
                          label: 'Monto Total \$',
                          width: 150,
                          type: TextInputType.number,
                          onSave: (value) {
                            montoTotal = double.parse(value!);
                          },
                          validate: true,
                        ),
                        InputForm(
                          label: 'Cuota Inicial \$',
                          width: 150,
                          type: TextInputType.number,
                          onSave: (value) {
                            cuotaInicial =
                                value!.isEmpty ? null : double.parse(value);
                          },
                          validate: false,
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InputForm(
                          width: 150,
                          label: 'Interés Anual %',
                          type: TextInputType.number,
                          initialValue: 0.09,
                          onSave: (value) {
                            interes = double.parse(value!);
                          },
                          validate: true,
                        ),
                        InputForm(
                          width: 150,
                          label: 'Tiempo (años)',
                          type: TextInputType.number,
                          onSave: (value) {
                            tiempo = double.parse(value!);
                          },
                          validate: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      height: 50,
                      width: 300,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            _formKey.currentState!.reset();
                            FocusScope.of(context).unfocus();

                            final cuotas = obtenerCuotas(
                                montoTotal!, interes!, tiempo!, cuotaInicial);

                            final Cotizacion cotizacionActual = Cotizacion(
                                interes: interes!,
                                montoTotal: montoTotal!,
                                montoCuotas: cuotas,
                                cuotaInicial: cuotaInicial,
                                tiempo: tiempo!);

                            cotizaciones.add(cotizacionActual);

                            guardarCotizaciones();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CotizacionPage(
                                    cotizacion: cotizacionActual),
                              ),
                            );
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
                ))
          ],
        ),
      ),
    );
  }
}
