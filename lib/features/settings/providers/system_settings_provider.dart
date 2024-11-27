import 'dart:convert';

import 'package:battlemaster/features/settings/models/encounter_settings.dart';
import 'package:battlemaster/features/settings/models/skip_dead_behavior.dart';
import 'package:flagsmith/flagsmith.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/initiative_roll_type.dart';
import '../models/settings.dart';

class SystemSettingsProvider extends ChangeNotifier {
  Settings _settings = Settings();
  final String _settingsKey = 'settings';
  final FlagsmithClient _flagsmithClient;

  SystemSettingsProvider({FlagsmithClient? flagsmithClient})
      : _flagsmithClient = flagsmithClient ??
            FlagsmithClient(
              apiKey: const String.fromEnvironment('FLAGSMITH_API_KEY'),
              config: FlagsmithConfig(
                baseURI: const String.fromEnvironment('FLAGSMTIH_URI'),
                isDebug: kDebugMode,
                enableAnalytics: true,
                enableRealtimeUpdates: true,
              ),
            ) {
    _init();
  }

  InitiativeRollType get rollType => _settings.encounterSettings.rollType;

  SkipDeadBehavior get skipDeadBehavior =>
      _settings.encounterSettings.skipDeadBehavior;

  ThemeMode get themeMode => _settings.themeMode;

  bool get analyticsEnabled => _settings.analyticsEnabled;

  Settings get settings => _settings;

  PF2eSettings get pf2eSettings => _settings.pf2eSettings;

  Dnd5eSettings get dnd5eSettings => _settings.dnd5eSettings;

  EncounterSettings get encounterSettings => _settings.encounterSettings;

  Future<void> _init() async {
    final preferences = await SharedPreferences.getInstance();
    final cache = jsonDecode(preferences.getString(_settingsKey) ?? '{}')
        as Map<String, dynamic>;
    if (cache.isNotEmpty) {
      _settings = Settings.fromJson(cache);
    }

    notifyListeners();
    await _flagsmithClient.initialize();
    await _flagsmithClient.getFeatureFlags(reload: true);
  }

  Future<bool> isFeatureEnabled(String featureKey) {
    return _flagsmithClient.isFeatureFlagEnabled(featureKey);
  }

  Future<String?> getFeatureFlagValue(String featureKey) {
    return _flagsmithClient.getFeatureFlagValue(featureKey);
  }

  Future<void> reset() async {
    _settings = Settings();
    notifyListeners();
    await _saveSettings();
    await _flagsmithClient.clearStore();
    await _flagsmithClient.getFeatureFlags(reload: true);
  }

  Future<void> _saveSettings() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _settingsKey,
      jsonEncode(_settings.toJson()),
    );
  }

  Future<void> setInitiativeRollType(InitiativeRollType rollType) async {
    _settings = _settings.copyWith(
      encounterSettings:
          _settings.encounterSettings.copyWith(rollType: rollType),
    );
    notifyListeners();
    await _saveSettings();
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    _settings = _settings.copyWith(themeMode: themeMode);
    notifyListeners();
    await _saveSettings();
  }

  Future<void> setSettings(Settings settings) async {
    _settings = settings;
    notifyListeners();
    await _saveSettings();
  }

  Future<void> setSkipDeadBehavior(SkipDeadBehavior skipDeadBehavior) async {
    await setSettings(
      _settings.copyWith(
        encounterSettings: _settings.encounterSettings.copyWith(
          skipDeadBehavior: skipDeadBehavior,
        ),
      ),
    );
  }

  Future<void> setEncounterSettings(EncounterSettings encounterSettings) async {
    await setSettings(settings.copyWith(encounterSettings: encounterSettings));
  }

  Future<void> setLiveEncounterSettings(
      LiveEncounterSettings liveEncounterSettings) async {
    await setSettings(
      settings.copyWith(
        encounterSettings: encounterSettings.copyWith(
          liveEncounterSettings: liveEncounterSettings,
        ),
      ),
    );
  }

  Future<void> setPF2eSettings(PF2eSettings pf2eSettings) async {
    _settings = _settings.copyWith(pf2eSettings: pf2eSettings);
    notifyListeners();
    await _saveSettings();
  }

  Future<void> set5eSettings(Dnd5eSettings dnd5eSettings) async {
    _settings = _settings.copyWith(dnd5eSettings: dnd5eSettings);
    await _saveSettings();
    notifyListeners();
  }
}
