import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class NumbericInput extends StatefulWidget {
  final bool enabled;
  final String? label;
  final TextEditingController? controller;
  final bool integer;

  const NumbericInput({
    this.label,
    this.controller,
    this.enabled = true,
    this.integer = false,
    super.key,
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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        style: hasError
            ? TextStyle(color: errorColor, fontSize: 14)
            : TextStyle(color: textColor, fontSize: 14),
        enabled: widget.enabled,
        controller: widget.controller,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[\d\.]')),
        ],
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: widget.label,
        ),
      ),
    );
  }
}
