import 'package:flutter/material.dart';

import 'pf2e_colors.dart';

final pf2eLightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: mainRed,
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
);

final pf2eDarkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: mainRed,
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
);
