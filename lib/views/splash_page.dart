import 'package:flutter/material.dart';

import '../custom/input_form.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InputForm(
          validate: true,
          width: MediaQuery.of(context).size.width - 45,
          label: "Introduce tu nombre",
        ),
      ),
    );
  }
}
