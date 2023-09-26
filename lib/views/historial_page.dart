import 'package:flutter/material.dart';

class HistorialPage extends StatelessWidget {
  final String message;

  const HistorialPage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Cotizaciones'),
      ),
      body: Column(children: [Text(message)]),
    );
  }
}
