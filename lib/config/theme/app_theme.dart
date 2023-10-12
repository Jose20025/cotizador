import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      colorSchemeSeed: Colors.orange,
      // brightness: Brightness.dark,
    );
  }
}
