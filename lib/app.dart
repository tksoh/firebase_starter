import 'package:firebase_starter/config/theme.dart';
import 'package:flutter/material.dart';

import 'drawer/drawer.dart';
import '/screens/home/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ThemeConfig.isDarkMode,
      builder: (context, value, child) {
        return MaterialApp(
          title: 'Firebase Starter',
          themeMode: ThemeConfig.appThemeMode,
          darkTheme: ThemeData.dark(),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: RootPage(),
        );
      },
    );
  }
}

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      body: const MyHomePage(title: 'Firebase Starter'),
    );
  }
}
