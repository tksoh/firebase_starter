import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'controllers.dart';

enum DateTimeInputMode {
  dateOnly,
  timeOnly,
  dateAndTime,
}

class DateTimeInput extends StatefulWidget {
  const DateTimeInput({
    super.key,
    required this.label,
    required this.controller,
    this.formatter,
    this.hintText,
    this.mode = DateTimeInputMode.dateAndTime,
  });

  final String label;
  final DateFormat? formatter;
  final DateTimeEditingController controller;
  final String? hintText;
  final DateTimeInputMode mode;

  @override
  State<DateTimeInput> createState() => _DateTimeInputState();
}

class _DateTimeInputState extends State<DateTimeInput> {
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
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: widget.hintText,
          hintStyle: const TextStyle(fontStyle: FontStyle.italic),
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
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    if (widget.mode == DateTimeInputMode.dateOnly) {
      selectedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(2022),
          lastDate: DateTime.now());
      if (selectedDate == null) return null;

      final now = DateTime.now();
      return DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        now.hour,
        now.minute,
      );
    } else if (widget.mode == DateTimeInputMode.timeOnly) {
      selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      if (selectedTime == null) return null;

      final now = DateTime.now();
      return DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );
    } else {
      // select both date and time
      selectedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(2022),
          lastDate: DateTime.now());
      if (selectedDate == null) return null;

      if (!mounted) return null;
      selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (selectedTime == null) return null;

      return DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
    }
  }
}
