import 'package:cotizador/custom/input_form.dart';
import 'package:cotizador/models/cotizacion.dart';
import 'package:cotizador/views/historial_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Cotizacion> cotizaciones = [
    Cotizacion(
        interes: 0.9,
        cuotaInicial: 200000,
        montoTotal: 300000,
        cuotas: 250,
        cantidadCuotas: 5,
        tiempo: 5),
    Cotizacion(
        interes: 0.45,
        cuotaInicial: 20003,
        montoTotal: 300343,
        cuotas: 22323,
        cantidadCuotas: 2,
        tiempo: 10)
  ];

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
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistorialPage(
                        cotizaciones: cotizaciones,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Historial de Cotizaciones',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Divider(),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InputForm(
                  label: 'Monto Total \$',
                  width: 150,
                  type: TextInputType.number,
                ),
                InputForm(
                  label: 'Cuota Inicial \$',
                  width: 150,
                  type: TextInputType.number,
                ),
              ],
            ),
            const SizedBox(height: 25),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InputForm(
                  width: 150,
                  label: 'Interés Anual %',
                  type: TextInputType.number,
                ),
                InputForm(width: 150, label: 'Tiempo (años)'),
              ],
            ),
            const SizedBox(height: 25),
            SizedBox(
              height: 50,
              width: 300,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  'Cotizar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
