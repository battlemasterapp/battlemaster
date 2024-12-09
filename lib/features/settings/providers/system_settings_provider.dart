import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/initiative_roll_type.dart';

class SystemSettings extends ChangeNotifier {
  InitiativeRollType _rollType = InitiativeRollType.manual;
  ThemeMode _themeMode = ThemeMode.system;

  SystemSettings() {
    _init();
  }

  Future<void> _init() async {
    // Load settings from disk
    final preferences = await SharedPreferences.getInstance();
    _rollType = InitiativeRollType.values[preferences.getInt('rollType') ?? 0];
    _themeMode = ThemeMode.values[preferences.getInt('themeMode') ?? 0];

    notifyListeners();
  }

  InitiativeRollType get rollType => _rollType;

  ThemeMode get themeMode => _themeMode;

  Future<void> setInitiativeRollType(InitiativeRollType rollType) async {
    _rollType = rollType;
    notifyListeners();

    // Save settings to disk
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt('rollType', rollType.index);
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;
    notifyListeners();

    // Save settings to disk
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt('themeMode', _themeMode.index);
  }
}
