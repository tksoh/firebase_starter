import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../extensions/math.dart';

class NumbericInput extends StatefulWidget {
  final bool enabled;
  final String? label;
  final TextEditingController? controller;
  final bool integer;
  final String? hintText;
  final double? stepSize;
  final int? decimals;

  const NumbericInput({
    super.key,
    this.label,
    this.controller,
    this.enabled = true,
    this.integer = false,
    this.hintText,
    this.stepSize,
    this.decimals,
  });

  @override
  State<NumbericInput> createState() => NumbericInputState();
}

class NumbericInputState extends State<NumbericInput> {
  bool hasError = false;

  @override
  void initState() {
    widget.controller?.addListener(textListener);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller?.removeListener(textListener);
    super.dispose();
  }

  void textListener() {
    final value = widget.controller!.text;
    if (value == '') {
      hasError = false;
    } else if (widget.integer) {
      hasError = int.tryParse(value) == null;
    } else {
      hasError = double.tryParse(value) == null;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final errorColor = themeData.colorScheme.error;
    final textColor =
        themeData.brightness == Brightness.light ? Colors.black : Colors.white;
    final filterPattern =
        widget.integer ? RegExp(r'^\-?[\d]*') : RegExp(r'^\-?\d*\.?\d*');
    var textStyle =
        hasError ? TextStyle(color: errorColor) : TextStyle(color: textColor);

    return TextFormField(
      style: textStyle,
      enabled: widget.enabled,
      controller: widget.controller,
      inputFormatters: [FilteringTextInputFormatter.allow(filterPattern)],
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        labelText: widget.label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: widget.hintText,
        hintStyle: const TextStyle(fontStyle: FontStyle.italic),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.remove), onPressed: decrement),
            IconButton(icon: const Icon(Icons.add), onPressed: increment),
          ],
        ),
      ),
    );
  }

  void decrement() {
    doMath('minus');
  }

  void increment() {
    doMath('plus');
  }

  void doMath(String op) {
    if (widget.stepSize == null || widget.controller == null) return;

    final oldValue = double.tryParse(widget.controller!.text) ?? 0.0;
    final newValue = op == 'plus'
        ? oldValue + widget.stepSize!
        : oldValue - widget.stepSize!;

    if (widget.integer) {
      widget.controller!.text = newValue.toInt().toString();
    } else {
      final decimals = widget.decimals == null
          ? max(oldValue.decimals(), widget.stepSize!.decimals())
          : widget.decimals!;
      widget.controller!.text = newValue.fixed(decimals).toString();
    }
  }
}
