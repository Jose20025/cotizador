import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/asesor.dart';
import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String? nombre;
  String? number;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

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
          if (_key.currentState!.validate()) {
            _key.currentState!.save();
            guardarAsesor();

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          }
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
            Form(
              key: _key,
              child: Column(
                children: [
                  Center(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa un nombre';
                        }

                        return null;
                      },
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      onSaved: (newValue) {
                        nombre = newValue;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Introduce tu nombre'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa un número';
                        }

                        return null;
                      },
                      keyboardType: TextInputType.number,
                      onSaved: (newValue) {
                        number = newValue;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Introduce tu número de teléfono'),
                        counter: Offstage(),
                      ),
                      maxLength: 8,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> guardarAsesor() async {
    final prefs = await SharedPreferences.getInstance();

    final Asesor asesor = Asesor(name: nombre!, number: number!);

    await prefs.setString('asesor', jsonEncode(asesor));
  }
}
