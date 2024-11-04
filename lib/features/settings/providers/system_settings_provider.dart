import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/initiative_roll_type.dart';



class SystemSettings extends ChangeNotifier {
  InitiativeRollType _rollType = InitiativeRollType.manual;

  SystemSettings() {
    _init();
  }

  InitiativeRollType get rollType => _rollType;

  Future<void> _init() async {
    // Load settings from disk
    final preferences = await SharedPreferences.getInstance();
    _rollType = InitiativeRollType.values[preferences.getInt('rollType') ?? 0];

    notifyListeners();
  }

  Future<void> setInitiativeRollType(InitiativeRollType rollType) async {
    _rollType = rollType;
    notifyListeners();

    // Save settings to disk
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt('rollType', rollType.index);

  }
}