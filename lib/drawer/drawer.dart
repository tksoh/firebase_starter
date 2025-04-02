import 'package:flutter/material.dart';

import 'widgets/sign_in.dart';
import '../screens/settings/settings_page.dart';
import 'widgets/drawer_menu.dart';

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
          const DrawerHeader(
            padding: EdgeInsets.all(0),
            child: SignInDrawerTile(),
          ),
          DrawerMenuBuilder(
            text: 'Setting',
            icon: Icons.settings,
            // action: showMaterialPage(SettingsPage()),
            action: () => showPage(const SettingsPage()),
          ),
          DrawerMenuBuilder(
            text: 'About',
            icon: Icons.info_outline,
            action: () => showAboutDialog(context: context),
          ),
        ],
      ),
    );
  }

  void showPage(Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => page,
      ),
    );
  }
}
