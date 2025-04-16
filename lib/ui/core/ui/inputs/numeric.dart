import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumbericInput extends StatefulWidget {
  final bool enabled;
  final String? label;
  final TextEditingController? controller;
  final bool integer;
  final String? hintText;

  const NumbericInput({
    super.key,
    this.label,
    this.controller,
    this.enabled = true,
    this.integer = false,
    this.hintText,
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
      ),
    );
  }
}
