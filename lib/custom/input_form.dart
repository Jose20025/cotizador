import 'package:flutter/material.dart';

class InputForm extends StatelessWidget {
  final double width;
  final String label;
  final int? initialValue;
  // final String? Function(String?)? validator;
  final int? maxLength;
  final TextInputType? type;
  final void Function(String?)? onSave;

  const InputForm({
    super.key,
    this.type,
    this.maxLength,
    this.initialValue,
    this.onSave,
    required this.width,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Obligatorio';
          }

          return null;
        },
        maxLength: maxLength ?? 10,
        keyboardType: type ?? type,
        initialValue: initialValue != null ? initialValue.toString() : '',
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
        onSaved: onSave,
      ),
    );
  }
}
