import 'package:flutter/material.dart';

class ThemeConfig {
  ThemeConfig._();

  static ValueNotifier<bool> isDarkMode = ValueNotifier(false);
  static ValueNotifier<bool> useMaterial3 = ValueNotifier(true);

  static ThemeMode get appThemeMode =>
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  static Color contrastColor(Color color) =>
      switch (ThemeData.estimateBrightnessForColor(color)) {
        Brightness.dark => Colors.white,
        Brightness.light => Colors.black
      };
}
