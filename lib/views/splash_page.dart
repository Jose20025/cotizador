import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final TextEditingController _nombreAsesorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hola Asesor',
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          guardarNombreAsesor();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        },
        icon: const Icon(Icons.login),
        label: const Text(
          'Ingresar',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 45),
            const Text(
              'Hola, ¿cómo deberíamos llamarte?',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Center(
                child: TextField(
              controller: _nombreAsesorController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Introduce tu nombre'),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Future<void> guardarNombreAsesor() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('asesor', _nombreAsesorController.value.text);
  }
}
