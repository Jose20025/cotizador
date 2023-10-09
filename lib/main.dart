import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols.dart';
import 'package:intl/number_symbols_data.dart';

import 'views/splash_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? nombreAsesor;

  @override
  void initState() {
    super.initState();
    comprobarAsesor();
  }

  void comprobarAsesor() async {
    final prefs = await SharedPreferences.getInstance();
    final asesorFromPrefs = prefs.getString('asesor');

    if (asesorFromPrefs == null) {
      return;
    }

    setState(() {
      nombreAsesor = asesorFromPrefs;
    });
  }

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = 'es_ES';
    initializeDateFormatting('es_ES', null);
    numberFormatSymbols['es_ES'] = const NumberSymbols(
        NAME: "es_ES",
        DECIMAL_SEP: ',',
        GROUP_SEP: '.',
        PERCENT: '%',
        ZERO_DIGIT: '0',
        PLUS_SIGN: '+',
        MINUS_SIGN: '-',
        EXP_SYMBOL: 'E',
        PERMILL: '\u2030',
        INFINITY: '\u221E',
        NAN: 'NaN',
        DECIMAL_PATTERN: '#,##0.###',
        SCIENTIFIC_PATTERN: '#E0',
        PERCENT_PATTERN: '#,##0\u00A0%',
        CURRENCY_PATTERN: '#,##0.00\u00A0\u00A4',
        DEF_CURRENCY_CODE: '\$');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        colorSchemeSeed: Colors.green,
        // brightness: Brightness.dark,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        colorSchemeSeed: Colors.green,
        brightness: Brightness.dark,
      ),
      title: 'Cotizador de Cuotas',
      home: nombreAsesor != null ? const HomePage() : const SplashPage(),
    );
  }
}
