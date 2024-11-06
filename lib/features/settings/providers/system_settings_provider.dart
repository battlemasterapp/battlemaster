import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/initiative_roll_type.dart';
import '../models/settings.dart';

class SystemSettingsProvider extends ChangeNotifier {
  Settings _settings = Settings();
  final String _settingsKey = 'settings';

  SystemSettingsProvider() {
    _init();
  }

  InitiativeRollType get rollType => _settings.rollType;

  ThemeMode get themeMode => _settings.themeMode;

  PF2eSettings get pf2eSettings => _settings.pf2eSettings;

  Future<void> _init() async {
    final preferences = await SharedPreferences.getInstance();
    final cache = jsonDecode(preferences.getString(_settingsKey) ?? '{}') as Map<String, dynamic>;
    if (cache.isNotEmpty) {
      _settings = Settings.fromJson(cache);
    }

    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_settingsKey, jsonEncode(_settings.toJson()));
  }

  Future<void> setInitiativeRollType(InitiativeRollType rollType) async {
    _settings = _settings.copyWith(rollType: rollType);
    notifyListeners();
    await _saveSettings();
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    _settings = _settings.copyWith(themeMode: themeMode);
    notifyListeners();
    await _saveSettings();
  }

  Future<void> setPF2eSettings(PF2eSettings pf2eSettings) async {
    _settings = _settings.copyWith(pf2eSettings: pf2eSettings);
    notifyListeners();
    await _saveSettings();
  }
}
