import 'package:flutter/material.dart';

import '../../config/theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark mode'),
            value: ThemeConfig.isDarkMode.value,
            onChanged: (value) {
              ThemeConfig.isDarkMode.value = !ThemeConfig.isDarkMode.value;
              // TODO: save dark mode preference
              // UserPreferences.saveDarkMode(ThemeConfig.isDarkMode.value);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
