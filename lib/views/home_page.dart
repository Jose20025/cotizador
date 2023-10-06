import 'dart:convert';

import '../custom/input_form.dart';
import '../models/cotizacion.dart';
import '../utils/proyectos.dart';
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

  //* VARIABLES
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double? precioMetroCuadrado;
  double? superficie;
  double? cuotaInicial;
  int? tiempo;
  String? referencia;
  int? numeroProyecto;

  //* METODOS

  Cotizacion crearCotizacion(double precioMetroCuadrado, double superficie,
      double? cuotaInicial, int tiempo, String referencia, int numeroProyecto) {
    double montoTotal = superficie * precioMetroCuadrado;

    if (cuotaInicial != null) {
      montoTotal -= cuotaInicial;
    }

    final mantenimiento = obtenerMontoMantenimiento(montoTotal);

    final montoPagar = (montoTotal + mantenimiento);

    final importeCuotas = montoPagar / tiempo;

    return Cotizacion(
      superficie: superficie,
      precioMetroCuadrado: precioMetroCuadrado,
      tiempo: tiempo,
      referencia: referencia,
      cuotaInicial: cuotaInicial,
      importeCuotas: importeCuotas,
      montoTotal: montoTotal,
      fecha: DateTime.now(),
      proyecto: proyectos[numeroProyecto]!,
    );
  }

  double obtenerMontoMantenimiento(double monto) {
    return monto * 8 / 100 * 10;
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

  //* BODY

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: appBody(context),
    );
  }

  SingleChildScrollView appBody(BuildContext context) {
    return SingleChildScrollView(
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistorialPage(
                      cotizaciones: cotizaciones.reversed.toList(),
                      eliminarHistorial: elimiarHistorial,
                    ),
                  ),
                );
              },
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
          DropdownMenu(
            onSelected: (value) {
              numeroProyecto = value;
            },
            label: const Text('Proyecto'),
            width: MediaQuery.of(context).size.width - 45,
            trailingIcon: const Icon(Icons.add_chart),
            dropdownMenuEntries: const [
              DropdownMenuEntry(value: 0, label: 'Cartagena 1'),
              DropdownMenuEntry(value: 1, label: 'Cartagena 2'),
              DropdownMenuEntry(value: 2, label: 'Mana 1'),
              DropdownMenuEntry(value: 3, label: 'Mana 2'),
              DropdownMenuEntry(value: 4, label: 'Mana 3'),
              DropdownMenuEntry(value: 5, label: 'Mana 4'),
              DropdownMenuEntry(value: 6, label: 'Mana 5'),
              DropdownMenuEntry(value: 7, label: 'Mana 6'),
            ],
          ),
          const SizedBox(height: 15),
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
                      width: 170,
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
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 30,
                  child: ElevatedButton(
                    style: const ButtonStyle(
                        elevation: MaterialStatePropertyAll(8),
                        shadowColor:
                            MaterialStatePropertyAll(Colors.transparent)),
                    onPressed: () async {
                      if (numeroProyecto == null) {
                        await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AlertDialog(
                            title: const Text('Error'),
                            content:
                                const Text('Debe de seleccionar un proyecto'),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Ok'),
                              )
                            ],
                          ),
                        );

                        return;
                      }

                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        FocusScope.of(context).unfocus();

                        final cotizacion = crearCotizacion(
                            precioMetroCuadrado!,
                            superficie!,
                            cuotaInicial,
                            tiempo!,
                            referencia!,
                            numeroProyecto!);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CotizacionPage(cotizacion: cotizacion),
                          ),
                        );
                      }
                    },
                    child: Text('Cotizar',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black)),
                  ),
                ),
                const SizedBox(height: 15),
                const Divider(),
                const SizedBox(height: 15),
                Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 30,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (numeroProyecto == null) {
                            await showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => AlertDialog(
                                title: const Text('Error'),
                                content: const Text(
                                    'Debe de seleccionar un proyecto'),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Ok'),
                                  )
                                ],
                              ),
                            );

                            return;
                          }

                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            _formKey.currentState!.reset();
                            FocusScope.of(context).unfocus();

                            final cotizacionAGuardar = crearCotizacion(
                                precioMetroCuadrado!,
                                superficie!,
                                cuotaInicial,
                                tiempo!,
                                referencia!,
                                numeroProyecto!);

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
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 30,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          _formKey.currentState!.reset();
                        },
                        style: const ButtonStyle(
                            elevation: MaterialStatePropertyAll(6),
                            shadowColor:
                                MaterialStatePropertyAll(Colors.transparent)),
                        child: const Text(
                          'Nueva Cotizacion',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'Cotizador de Cuotas',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
      centerTitle: true,
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
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
        elevation: 0,
        padding: EdgeInsets.all(20),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }
}
