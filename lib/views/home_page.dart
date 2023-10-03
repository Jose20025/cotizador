import 'dart:convert';

import '../custom/input_form.dart';
import '../models/cotizacion.dart';
import 'cotizacion_asesor_page.dart';
import 'cotizacion_cliente_page.dart';
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

  void cotizarCliente(Cotizacion cotizacion) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CotizacionClientePage(cotizacion: cotizacion),
      ),
    );
  }

  void cotizarAsesor(Cotizacion cotizacion) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CotizacionAsesorPage(cotizacion: cotizacion),
      ),
    );
  }

  // Eliminar Historial
  Future<void> elimiarHistorial() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: const Text('¿Estás seguro de borrar el historial?'),
        title: const Text("Confirmación"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                cotizaciones.clear();
                guardarCotizaciones();
              });
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HistorialPage(
                    cotizaciones: cotizaciones,
                    eliminarHistorial: elimiarHistorial),
              ));
            },
            child: const Text("Si"),
          ),
        ],
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double? precioMetroCuadrado;
  double? superficie;
  double? cuotaInicial;
  int? tiempo;
  String? referencia;

  Cotizacion crearCotizacion(double precioMetroCuadrado, double superficie,
      double? cuotaInicial, int tiempo, String referencia) {
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
      referencia: referencia,
      cuotaInicial: cuotaInicial,
      importeCuotas: importeCuotas,
      mantenimiento: mantenimiento,
      montoPagar: montoPagar,
      montoTotal: montoTotal,
      fecha: DateTime.now(),
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
          cotizaciones: cotizaciones.reversed.toList(),
          eliminarHistorial: elimiarHistorial,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cotizador de Cuotas',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              width: 300,
              child: ElevatedButton(
                style: const ButtonStyle(
                    elevation: MaterialStatePropertyAll(9),
                    shadowColor: MaterialStatePropertyAll(Colors.transparent)),
                onPressed: buttonPress,
                child: const Text(
                  'Historial de Cotizaciones',
                  style: TextStyle(
                    fontSize: 18,
                    // color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  InputForm(
                    validate: true,
                    maxLength: 30,
                    width: MediaQuery.of(context).size.width - 45,
                    label: 'Nombre de Referencia',
                    textCapitalization: TextCapitalization.words,
                    onSave: (value) {
                      referencia = value!;
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InputForm(
                        validate: true,
                        width: 150,
                        label: 'Precio de m²',
                        maxLength: 10,
                        type: TextInputType.number,
                        onSave: (value) {
                          precioMetroCuadrado = double.parse(value!);
                        },
                      ),
                      InputForm(
                        validate: true,
                        maxLength: 10,
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InputForm(
                        validate: false,
                        width: 150,
                        label: 'Cuota Inicial',
                        type: TextInputType.number,
                        onSave: (value) {
                          cuotaInicial =
                              value!.isNotEmpty ? double.parse(value) : null;
                        },
                      ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      botonCotizarCliente(context),
                      botonCotizarAsesor(context),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Divider(),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 30,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _formKey.currentState!.reset();
                          FocusScope.of(context).unfocus();

                          final cotizacionAGuardar = crearCotizacion(
                              precioMetroCuadrado!,
                              superficie!,
                              cuotaInicial,
                              tiempo!,
                              referencia!);

                          cotizaciones.add(cotizacionAGuardar);

                          guardarCotizaciones();

                          showConfirmation(context);
                        }
                      },
                      style: const ButtonStyle(
                          elevation: MaterialStatePropertyAll(6),
                          shadowColor:
                              MaterialStatePropertyAll(Colors.transparent)),
                      child: const Text(
                        'Guardar Cotizacion',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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

  void showConfirmation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Center(
          child: Text(
            'Se ha guardado la cotización con éxito en el historial',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.green,
        elevation: 0,
        padding: EdgeInsets.all(20),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }

  SizedBox botonCotizarAsesor(BuildContext context) {
    return SizedBox(
      height: 70,
      width: 170,
      child: ElevatedButton(
        style: const ButtonStyle(
          elevation: MaterialStatePropertyAll(8),
          surfaceTintColor: MaterialStatePropertyAll(Colors.red),
          shadowColor: MaterialStatePropertyAll(Colors.transparent),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            FocusScope.of(context).unfocus();

            final cotizacion = crearCotizacion(precioMetroCuadrado!,
                superficie!, cuotaInicial, tiempo!, referencia!);

            cotizarAsesor(cotizacion);
          }
        },
        child: Text(
          'Cotizar a \nAsesor',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  SizedBox botonCotizarCliente(BuildContext context) {
    return SizedBox(
      height: 70,
      width: 170,
      child: ElevatedButton(
        style: const ButtonStyle(
            elevation: MaterialStatePropertyAll(8),
            shadowColor: MaterialStatePropertyAll(Colors.transparent)),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            FocusScope.of(context).unfocus();

            final cotizacion = crearCotizacion(precioMetroCuadrado!,
                superficie!, cuotaInicial, tiempo!, referencia!);

            cotizarCliente(cotizacion);
          }
        },
        child: Text('Cotizar a Cliente',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black)),
      ),
    );
  }
}
