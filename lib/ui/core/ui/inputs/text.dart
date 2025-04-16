import 'package:flutter/material.dart';

class SimpleTextInput extends StatelessWidget {
  const SimpleTextInput({
    super.key,
    required this.label,
    this.controller,
    this.hintText,
  });

  final String label;
  final TextEditingController? controller;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: hintText,
        hintStyle: const TextStyle(fontStyle: FontStyle.italic),
      ),
    );
  }
}
