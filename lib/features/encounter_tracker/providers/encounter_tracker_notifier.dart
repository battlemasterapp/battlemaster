import 'dart:async';
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
  int _activeCombatantIndex = 0;
  final _activeIndexController = StreamController<int>();

  EncounterTrackerNotifier({
    required AppDatabase database,
    required SystemSettings settings,
    required this.encounterId,
  })  : _database = database,
        _settings = settings {
    watchEncounter().listen((encounter) {
      _encounter = encounter;
    });
  }

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

  Stream<int> get activeIndexStream => _activeIndexController.stream;

  void _setActiveCombatantIndex(int index) {
    _activeCombatantIndex = index;
    _activeIndexController.add(_activeCombatantIndex);
  }

  Future<void> playStop() async {
    if (_status == EncounterTrackerStatus.stopped) {
      _status = EncounterTrackerStatus.playing;
    } else {
      _status = EncounterTrackerStatus.stopped;
    }
    _round = 1;
    _setActiveCombatantIndex(0);
    notifyListeners();
  }

  Future<void> rollInitiative() async {
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

  Future<void> reorderCombatants(int oldIndex, int newIndex) async {
    final combatants = _encounter.combatants;
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = combatants.removeAt(oldIndex);
    combatants.insert(newIndex, item);
    await _database
        .updateEncounter(_encounter.copyWith(combatants: combatants));
  }

  void nextRound() {
    if (!isPlaying) {
      return;
    }
    _round++;
    _setActiveCombatantIndex(0);
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
    _setActiveCombatantIndex(_activeCombatantIndex);
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
    _setActiveCombatantIndex(_activeCombatantIndex);
    notifyListeners();
  }

  void previousTurn() {
    if (!isPlaying) {
      return;
    }
    _activeCombatantIndex--;
    if (_activeCombatantIndex < 0) {
      _activeCombatantIndex = _encounter.combatants.length - 1;
      if (round > 1) {
        return previousRound();
      }
      _activeCombatantIndex = 0;
    }
    _setActiveCombatantIndex(_activeCombatantIndex);
    notifyListeners();
  }
}
