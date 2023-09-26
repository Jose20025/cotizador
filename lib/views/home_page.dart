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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistorialPage(
                        cotizaciones: cotizaciones,
                      ),
                    ));
              },
              child: const Text('Historial de Cotizaciones'),
            )
          ],
        ),
      ),
    );
  }
}
