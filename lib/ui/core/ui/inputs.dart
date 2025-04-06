import 'package:flutter/material.dart';

class SimpleTextInput extends StatelessWidget {
  const SimpleTextInput({
    super.key,
    required this.label,
    this.controller,
  });

  final String label;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        labelText: label,
      ),
    );
  }
}
