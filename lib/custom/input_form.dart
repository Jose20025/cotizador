import 'package:flutter/material.dart';

class InputForm extends StatelessWidget {
  final double width;
  final String label;
  final TextCapitalization? textCapitalization;
  final bool validate;
  final int? maxLength;
  final TextInputType? type;
  final void Function(String?)? onSave;

  const InputForm({
    super.key,
    this.type,
    this.maxLength,
    this.onSave,
    this.textCapitalization,
    required this.validate,
    required this.width,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        validator: validate
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Obligatorio';
                }

                return null;
              }
            : null,
        maxLength: maxLength ?? 15,
        keyboardType: type ?? TextInputType.text,
        textCapitalization: textCapitalization ?? TextCapitalization.none,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18),
        decoration: InputDecoration(
            label: Text(label),
            counter: const SizedBox(),
            filled: true,
            border: const OutlineInputBorder()),
        onSaved: onSave,
      ),
    );
  }
}
