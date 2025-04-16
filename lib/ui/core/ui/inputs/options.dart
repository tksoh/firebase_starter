// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

class OptionInput extends StatefulWidget {
  const OptionInput({
    super.key,
    required this.label,
    required this.options,
    required this.selected,
    this.selectMultiple = false,
  });

  final String label;
  final List<String> options;
  final bool selectMultiple;
  final Set<String> selected;

  @override
  State<OptionInput> createState() => _OptionInputState();
}

class _OptionInputState extends State<OptionInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(widget.label),
        ),
        SegmentedButton(
          segments: widget.options
              .map((e) => ButtonSegment<String>(value: e, label: Text(e)))
              .toList(),
          selected: widget.selected,
          onSelectionChanged: updateSelected,
          emptySelectionAllowed: true,
          multiSelectionEnabled: widget.selectMultiple,
          // direction: Axis.vertical,
          style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void updateSelected(Set<String> newSelection) {
    debugPrint('Options selected: $newSelection');
    setState(() {
      widget.selected.clear();
      widget.selected.addAll(newSelection);
    });
  }
}
