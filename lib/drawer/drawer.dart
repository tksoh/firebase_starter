import 'package:firebase_starter/screens/settings/settings_page.dart';
import 'package:flutter/material.dart';

import 'sign_in.dart';

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
            child: SignInDrawerTile(),
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SettingsPage(),
              ));
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
