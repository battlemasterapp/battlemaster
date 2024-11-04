import 'package:flutter/material.dart';

import 'pf2e_colors.dart';

final pf2eLightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: mainRed,
  colorScheme: ColorScheme.fromSeed(
    seedColor: mainRed,
    secondary: mainBlue,
    brightness: Brightness.light,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: mainRed,
    foregroundColor: Colors.white,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: mainBlue,
    foregroundColor: Colors.white,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
);

final pf2eDarkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: mainRed,
  colorScheme: ColorScheme.fromSeed(
    seedColor: mainRed,
    secondary: mainBlue,
    brightness: Brightness.dark,
    surface: darkBackground,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: mainRed,
    foregroundColor: Colors.white,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: mainBlue,
    foregroundColor: Colors.white,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
);
