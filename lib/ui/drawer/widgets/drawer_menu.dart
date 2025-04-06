import 'package:flutter/material.dart';

class DrawerMenuBuilder extends StatelessWidget {
  const DrawerMenuBuilder({
    super.key,
    required this.text,
    required this.icon,
    this.closeDrawer = true,
    required this.action,
  });

  final String text;
  final IconData icon;
  final VoidCallback action;
  final bool closeDrawer;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: () {
        if (closeDrawer) Navigator.pop(context); // close drawer
        action();
      },
    );
  }
}
