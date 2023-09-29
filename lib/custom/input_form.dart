import 'package:flutter/material.dart';

class InputForm extends StatelessWidget {
  final double width;
  final String label;
  final TextInputType? type;

  const InputForm({
    super.key,
    this.type,
    required this.width,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        maxLength: 10,
        keyboardType: type ?? type,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          label: Center(
            child: Text(label),
          ),
          counter: const Offstage(),
          filled: true,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
        ),
      ),
    );
  }
}
