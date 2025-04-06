import 'package:flutter/material.dart';

import 'config/theme.dart';
import 'ui/drawer/drawer.dart';
import 'ui/home/home_page.dart';

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
          home: const RootPage(),
        );
      },
    );
  }
}

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: MyDrawer(),
      body: MyHomePage(title: 'Firebase Starter'),
    );
  }
}
