import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'controllers.dart';

class DateInput extends StatefulWidget {
  const DateInput({
    super.key,
    required this.label,
    required this.controller,
    this.formatter,
  });

  final String label;
  final DateFormat? formatter;
  final DateTimeEditingController controller;

  @override
  State<DateInput> createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  final dateCtrl = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    dateCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final textColor =
        themeData.brightness == Brightness.light ? Colors.black : Colors.white;
    return GestureDetector(
      onTap: () {
        selectNewDate();
      },
      child: TextFormField(
        style: TextStyle(color: textColor),
        controller: widget.controller,
        decoration: InputDecoration(
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: themeData.dividerColor),
          ),
          labelText: widget.label,
          labelStyle: TextStyle(
            color: themeData.colorScheme.onSecondaryContainer,
          ),
        ),
        enabled: false,
      ),
    );
  }

  void selectNewDate({DateTime? initDate}) async {
    final date = await pickDateTime(initDate: initDate);
    // final formatter = widget.formatter ?? DateFormat('d/M/y hh:mm:ss a');
    if (date != null) {
      setState(() {
        dateCtrl.text = widget.controller.text; // formatter.format(date);
        widget.controller.data = date;
      });
    }
  }

  Future<DateTime?> pickDateTime({DateTime? initDate}) async {
    final initialDate = initDate ?? DateTime.now();

    var selectedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2022),
        lastDate: DateTime.now());

    if (selectedDate == null) return null;

    if (!mounted) return null;
    var selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );

    return selectedTime == null
        ? selectedDate
        : DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
  }
}
