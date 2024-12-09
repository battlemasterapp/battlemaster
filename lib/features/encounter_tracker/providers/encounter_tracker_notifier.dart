import 'package:flutter/material.dart';

import '../../../database/database.dart';
import '../../encounters/models/encounter.dart';
import '../../engines/models/game_engine_type.dart';

enum EncounterTrackerStatus {
  stopped,
  playing,
}

class EncounterTrackerNotifier extends ChangeNotifier {
  final AppDatabase _database;
  final int encounterId;

  EncounterTrackerNotifier({
    required AppDatabase database,
    required this.encounterId,
  }) : _database = database {
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
    } else {
      _status = EncounterTrackerStatus.stopped;
    }
    _activeCombatantIndex = 0;
    _round = 1;
    notifyListeners();
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
