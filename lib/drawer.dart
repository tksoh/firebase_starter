import 'package:flutter/material.dart';

import 'firework/sign_in.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    final stbarHeight = MediaQuery.of(context).viewPadding.top;

    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          SizedBox(height: stbarHeight),
          DrawerHeader(
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
              // color: Theme.of(context).colorScheme.inversePrimary,
            ),
            child: SignInTile(),
          ),
          ListTile(
            title: const Text('Item 1'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
        ],
      ),
    );
  }
}
