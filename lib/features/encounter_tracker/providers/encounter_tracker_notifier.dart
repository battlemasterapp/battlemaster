import 'dart:math';

import 'package:battlemaster/features/settings/providers/system_settings_provider.dart';
import 'package:flutter/material.dart';

import '../../../database/database.dart';
import '../../combatant/models/combatant_type.dart';
import '../../encounters/models/encounter.dart';
import '../../engines/models/game_engine_type.dart';
import '../../settings/models/initiative_roll_type.dart';

enum EncounterTrackerStatus {
  stopped,
  playing,
}

class EncounterTrackerNotifier extends ChangeNotifier {
  final AppDatabase _database;
  final SystemSettings _settings;
  final int encounterId;

  EncounterTrackerNotifier({
    required AppDatabase database,
    required SystemSettings settings,
    required this.encounterId,
  })  : _database = database,
        _settings = settings {
    watchEncounter().listen((encounter) {
      debugPrint('Encounter updated: $encounter');
      _encounter = encounter;
    });
  }

  int _activeCombatantIndex = 0;
  int _round = 1;
  late Encounter _encounter;
  EncounterTrackerStatus _status = EncounterTrackerStatus.stopped;

  int get activeCombatantIndex => _activeCombatantIndex;

  int get round => _round;

  EncounterTrackerStatus get status => _status;

  bool get isPlaying => _status == EncounterTrackerStatus.playing;

  Stream<Encounter> watchEncounter() {
    return (_database.select(_database.encounterTable)
          ..where((e) => e.id.equals(encounterId)))
        .watchSingle()
        .asyncMap<Encounter>(
          (row) => Encounter(
            id: row.id,
            name: row.name,
            type: row.type,
            combatants: row.combatants,
            engine: GameEngineType.values[row.engine],
          ),
        );
  }

  Future<void> playStop() async {
    if (_status == EncounterTrackerStatus.stopped) {
      _status = EncounterTrackerStatus.playing;
      await _rollInitiative();
    } else {
      _status = EncounterTrackerStatus.stopped;
    }
    _activeCombatantIndex = 0;
    _round = 1;
    notifyListeners();
  }

  Future<void> _rollInitiative() async {
    if (_settings.rollType == InitiativeRollType.manual) {
      return;
    }

    final combatants = _encounter.combatants.map((c) {
      final roll = Random().nextInt(20) + 1 + c.initiativeModifier;
      if (_settings.rollType == InitiativeRollType.monstersOnly) {
        if (c.type != CombatantType.monster) {
          return c;
        }
      }
      return c.copyWith(initiative: roll.toDouble());
    }).toList()
      ..sort((a, b) => b.initiative.compareTo(a.initiative));
    await _database
        .updateEncounter(_encounter.copyWith(combatants: combatants));
  }

  void nextRound() {
    if (!isPlaying) {
      return;
    }
    _round++;
    _activeCombatantIndex = 0;
    notifyListeners();
  }

  void previousRound() {
    if (!isPlaying) {
      return;
    }
    if (_round == 1) {
      return;
    }
    _round--;
    notifyListeners();
  }

  void nextTurn() {
    if (!isPlaying) {
      return;
    }
    _activeCombatantIndex++;
    if (_activeCombatantIndex >= _encounter.combatants.length) {
      return nextRound();
    }
    notifyListeners();
  }

  void previousTurn() {
    if (!isPlaying) {
      return;
    }
    _activeCombatantIndex--;
    if (_activeCombatantIndex < 0) {
      _activeCombatantIndex = _encounter.combatants.length - 1;
      return previousRound();
    }
    notifyListeners();
  }
}
