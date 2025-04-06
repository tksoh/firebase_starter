import 'package:flutter/material.dart';

class SimpleConfirmDialog extends StatelessWidget {
  const SimpleConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actionTextList,
  });

  final String title;
  final String content;
  final List<String> actionTextList;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: actionTextList
          .map(
            (e) => TextButton(
              onPressed: () => Navigator.of(context).pop(e),
              child: Text(e),
            ),
          )
          .toList(),
    );
  }
}
