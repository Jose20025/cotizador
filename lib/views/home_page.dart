import 'dart:convert';

import '../custom/input_form.dart';
import '../models/asesor.dart';
import '../models/cotizacion.dart';
import '../utils/cotizaciones.dart';
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
    obtenerAsesor();
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
  Asesor? asesor;

  void obtenerCotizaciones() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final cotizacionesJson = prefs.getString('historial');

    if (cotizacionesJson == null) return;

    final List<dynamic> jsonList = json.decode(cotizacionesJson);

    for (var elemento in jsonList) {
      cotizaciones.add(Cotizacion.fromJson(elemento));
    }
  }

  void obtenerAsesor() async {
    final prefs = await SharedPreferences.getInstance();
    final asesorFromPrefs = prefs.getString('asesor');

    setState(() {
      asesor = Asesor.fromJson(jsonDecode(asesorFromPrefs!));
    });
  }

  void guardarCotizaciones() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final cotizacionesJson = json.encode(cotizaciones);

    await prefs.setString('historial', cotizacionesJson);
  }

  // Eliminar Historial
  void eliminarHistorial() async {
    cotizaciones.clear();
    guardarCotizaciones();
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
                      eliminarHistorial: eliminarHistorial,
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
          SizedBox(
            width: MediaQuery.of(context).size.width - 45,
            child: SingleChildScrollView(
                child: DropdownButtonFormField<int>(
              value: numeroProyecto,
              onChanged: (newvalue) {
                setState(() {
                  numeroProyecto = newvalue;
                });
              },
              hint: const Text('Proyecto'),
              icon: const Icon(Icons.add_chart),
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: const [
                // TODO automatizar esto
                DropdownMenuItem<int>(value: 0, child: Text('Cartagena 1')),
                DropdownMenuItem<int>(value: 1, child: Text('Cartagena 2')),
                DropdownMenuItem<int>(value: 2, child: Text('Mana 1')),
                DropdownMenuItem<int>(value: 3, child: Text('Mana 2')),
                DropdownMenuItem<int>(value: 4, child: Text('Mana 3')),
                DropdownMenuItem<int>(value: 5, child: Text('Mana 4')),
                DropdownMenuItem<int>(value: 6, child: Text('Mana 5')),
                DropdownMenuItem<int>(value: 7, child: Text('Mana 6')),
              ],
            )),
          ),
          const SizedBox(height: 15),
          Form(
            key: _formKey,
            child: Column(
              children: [
                InputForm(
                  validate: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Obligatorio';
                    }

                    return null;
                  },
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InputForm(
                      validate: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Obligatorio';
                        }

                        return null;
                      },
                      width: 150,
                      label: 'Precio de m²',
                      maxLength: 10,
                      type: TextInputType.number,
                      onSave: (value) {
                        precioMetroCuadrado = double.parse(value!);
                      },
                    ),
                    const SizedBox(width: 30),
                    InputForm(
                      validate: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Obligatorio';
                        }

                        return null;
                      },
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InputForm(
                      validate: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Obligatorio';
                        }

                        if (double.parse(value) < 200) {
                          return 'Minimo 200';
                        }

                        return null;
                      },
                      width: 150,
                      label: 'Cuota Inicial',
                      type: TextInputType.number,
                      onSave: (value) {
                        cuotaInicial =
                            value!.isNotEmpty ? double.parse(value) : null;
                      },
                    ),
                    const SizedBox(width: 30),
                    InputForm(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Obligatorio';
                        }

                        return null;
                      },
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

                        try {
                          final cotizacion = crearCotizacion(
                              precioMetroCuadrado!,
                              superficie!,
                              cuotaInicial!,
                              tiempo!,
                              referencia!,
                              numeroProyecto!);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CotizacionPage(
                                cotizacion: cotizacion,
                                asesor: asesor!,
                              ),
                            ),
                          );
                        } on HigherFirstPaymentError {
                          await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => AlertDialog(
                              elevation: 5,
                              title: const Text('Error'),
                              icon: const Icon(Icons.error),
                              content: const Text(
                                'La cuota inicial no debe ser mayor al monto del lote',
                                textAlign: TextAlign.center,
                              ),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Ok'))
                              ],
                            ),
                          );
                        } on EqualError {
                          await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => AlertDialog(
                              elevation: 5,
                              title: const Text('Error'),
                              icon: const Icon(Icons.error),
                              content: const Text(
                                'La cuota inicial es igual al monto total del lote, no se pagará con cuotas',
                                textAlign: TextAlign.center,
                              ),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Ok'))
                              ],
                            ),
                          );
                        }
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
                                elevation: 5,
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

                            try {
                              final cotizacionAGuardar = crearCotizacion(
                                  precioMetroCuadrado!,
                                  superficie!,
                                  cuotaInicial!,
                                  tiempo!,
                                  referencia!,
                                  numeroProyecto!);

                              setState(() {
                                numeroProyecto = null;
                              });

                              cotizaciones.add(cotizacionAGuardar);

                              guardarCotizaciones();

                              showSnackBar(context,
                                  'Se ha guardado la cotización con éxito en el historial');

                              _formKey.currentState!.reset();
                              FocusScope.of(context).unfocus();
                            } on HigherFirstPaymentError {
                              await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => AlertDialog(
                                  elevation: 5,
                                  title: const Text('Error'),
                                  icon: const Icon(Icons.error),
                                  content: const Text(
                                    'La cuota inicial no debe ser mayor al monto del lote',
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Ok'))
                                  ],
                                ),
                              );
                            } on EqualError {
                              await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => AlertDialog(
                                  elevation: 5,
                                  title: const Text('Error'),
                                  icon: const Icon(Icons.error),
                                  content: const Text(
                                    'La cuota inicial es igual al monto total del lote, no se pagará con cuotas',
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Ok'))
                                  ],
                                ),
                              );
                            }
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
                          setState(() {
                            numeroProyecto = null;
                          });
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

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        elevation: 0,
        padding: const EdgeInsets.all(20),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }
}
