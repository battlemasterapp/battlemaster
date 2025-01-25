import 'dart:async';
import 'dart:math';

import 'package:battlemaster/features/combatant/models/combatant.dart';
import 'package:battlemaster/features/combatant/models/combatant_data.dart';
import 'package:battlemaster/features/conditions/models/condition.dart';
import 'package:battlemaster/features/encounter_tracker/providers/share_encounter_notifier.dart';
import 'package:battlemaster/features/encounters/models/encounter_log.dart';
import 'package:battlemaster/features/settings/models/skip_dead_behavior.dart';
import 'package:battlemaster/features/settings/providers/system_settings_provider.dart';
import 'package:battlemaster/features/sync/providers/sync_encounter_repository.dart';
import 'package:flutter/material.dart';
import 'package:nanoid2/nanoid2.dart';

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
  final SystemSettingsProvider _settings;
  final int encounterId;
  int _activeCombatantIndex = 0;
  final _activeIndexController = StreamController<int>();
  ShareEncounterNotifier? shareEncounterNotifier;
  SyncEncounterRepository _encounterRepository;

  EncounterTrackerNotifier({
    required AppDatabase database,
    required SystemSettingsProvider settings,
    required this.encounterId,
    this.shareEncounterNotifier,
    required SyncEncounterRepository encounterRepo,
  })  : _database = database,
        _settings = settings,
        _encounterRepository = encounterRepo;

  set encounterRepo(SyncEncounterRepository repo) {
    _encounterRepository = repo;
  }

  @override
  void dispose() {
    _activeIndexController.close();
    super.dispose();
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
      (row) async {
        _encounter = Encounter(
          id: row.id,
          name: row.name,
          type: row.type,
          combatants: row.combatants,
          engine: GameEngineType.values[row.engine],
          round: row.round,
          turn: row.turn,
          logs: row.logs,
          syncId: row.syncId,
        );
        await shareEncounterNotifier?.updateEncounter(_encounter);
        return _encounter;
      },
    );
  }

  Stream<int> get activeIndexStream => _activeIndexController.stream;

  void _setActiveCombatantIndex(int index) {
    _activeCombatantIndex = index;
    _activeIndexController.add(_activeCombatantIndex);
  }

  Future<void> _update(Encounter encounter) async {
    await _database.updateEncounter(encounter);
    final syncId = await _encounterRepository.upsertEncounter(encounter);
    if (syncId != null && encounter.syncId == null) {
      await _database.updateEncounter(encounter.copyWith(syncId: syncId));
    }
  }

  Future<void> editName(String name) async {
    await _update(_encounter.copyWith(name: name));
  }

  Future<void> updateCombatantInitiative(
    Combatant combatant,
    double initiative,
  ) async {
    final log = CombatantInitiativeLog(
      round: _encounter.round,
      turn: _encounter.turn,
      combatant: combatant,
      initiative: initiative,
    );

    final updated = log.apply(_encounter);
    await _update(updated);
  }

  Future<void> updateCombatantHealth(
    Combatant combatant,
    int health,
  ) async {
    final damage = combatant.currentHp - health;
    if (damage == 0) {
      return;
    }

    final log = DamageCombatantLog(
      round: _encounter.round,
      turn: _encounter.turn,
      combatant: combatant,
      damage: damage,
    );

    final updated = log.apply(_encounter);
    await _update(updated);
  }

  Future<void> updateCombatantsConditions(
    Combatant combatant,
    List<Condition> conditions,
  ) async {
    final log = AddConditionsLog(
      round: _encounter.round,
      turn: _encounter.turn,
      combatant: combatant,
      conditions: conditions,
    );

    final updated = log.apply(_encounter);
    await _update(updated);
  }

  Future<void> updateCombatantData(
    Combatant combatant,
    CombatantData data,
  ) async {
    await _update(_encounter.copyWith(
      combatants: _encounter.combatants.map((c) {
        if (c.id == combatant.id) {
          return c.updateCombatantData(data);
        }
        return c;
      }).toList(),
    ));
  }

  Future<void> updateCombatant(Combatant combatant) async {
    await _update(_encounter.copyWith(
      combatants: _encounter.combatants.map((c) {
        if (c.id == combatant.id) {
          return combatant;
        }
        return c;
      }).toList(),
    ));
  }

  Future<void> addCombatants(Map<Combatant, int> combatantsMap) async {
    if (combatantsMap.isEmpty) {
      return;
    }
    final logs = combatantsMap.entries.fold<List<AddCombatantLog>>(
      [],
      (combatants, mapEntry) {
        return [
          ...combatants,
          ...List.generate(
            mapEntry.value,
            (index) => AddCombatantLog(
              round: _encounter.round,
              turn: _encounter.turn,
              combatant: mapEntry.key.copyWith(
                id: nanoid(),
                name: mapEntry.value > 1
                    ? '${mapEntry.key.name} ${index + 1}'
                    : null,
              ),
            ),
          ),
        ];
      },
    );

    final updated = logs.fold<Encounter>(
      _encounter,
      (e, log) => log.apply(e),
    );
    await _update(updated);
  }

  Future<void> removeCombatant(Combatant combatant) async {
    final removeLog = RemoveCombatantLog(
      round: _encounter.round,
      turn: _encounter.turn,
      combatant: combatant,
    );
    final updated = removeLog.apply(_encounter);
    await _update(updated);
  }

  Future<void> deleteHistory() async {
    final updated = _encounter.copyWith(logs: []);
    await _update(updated);
  }

  Future<void> undoLog(EncounterLog log) async {
    final updated = log.undo(_encounter);
    await _update(updated);
  }

  Future<void> playStop() async {
    if (_status == EncounterTrackerStatus.stopped) {
      _status = EncounterTrackerStatus.playing;
    } else {
      _status = EncounterTrackerStatus.stopped;
    }
    _round = _encounter.round;
    _setActiveCombatantIndex(
        min(_encounter.turn, _encounter.combatants.length - 1));
    notifyListeners();
  }

  Future<void> rollInitiative() async {
    if (_settings.rollType == InitiativeRollType.manual) {
      return;
    }

    final List<CombatantInitiativeLog> logs = _encounter.combatants.where((c) {
      final monstersOnly =
          _settings.rollType == InitiativeRollType.monstersOnly;
      return !monstersOnly || c.type == CombatantType.monster;
    }).map((c) {
      final roll = Random().nextInt(20) + 1 + c.initiativeModifier;
      return CombatantInitiativeLog(
        round: _encounter.round,
        turn: _encounter.turn,
        combatant: c,
        initiative: roll.toDouble(),
      );
    }).toList();

    final updated = logs.fold<Encounter>(
      _encounter,
      (e, log) => log.apply(e),
    );

    await _update(
      updated.copyWith(
        combatants: updated.combatants
          ..sort((a, b) => b.initiative.compareTo(a.initiative)),
      ),
    );
  }

  double _getReorderInitiative(int oldIndex, int newIndex) {
    final combatants = List<Combatant>.from(_encounter.combatants);
    combatants.removeAt(oldIndex);

    if (newIndex == combatants.length) {
      // We're at the end
      return combatants.last.initiative - 0.5;
    }

    final beforeCombatant = newIndex - 1 >= 0 ? combatants[newIndex - 1] : null;
    final afterCombatant = combatants[newIndex];

    if (beforeCombatant == null) {
      // We're at the top
      return combatants.first.initiative + 0.5;
    }

    return (beforeCombatant.initiative + afterCombatant.initiative) / 2;
  }

  Future<void> reorderCombatants(int oldIndex, int newIndex) async {
    final combatants = _encounter.combatants;
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final newInitiative = _getReorderInitiative(oldIndex, newIndex);

    final log = CombatantInitiativeLog(
      round: _encounter.round,
      turn: _encounter.turn,
      combatant: combatants[oldIndex],
      initiative: newInitiative,
    );

    final item = combatants.removeAt(oldIndex);
    combatants.insert(newIndex, item);

    final updated = log.apply(
      _encounter.copyWith(
        combatants: combatants,
      ),
    );

    await _update(updated);
  }

  Future<void> nextRound() async {
    if (!isPlaying) {
      return;
    }

    _round++;
    final skipDead = _settings.skipDeadBehavior;
    final firstIndex = _encounter.combatants.indexWhere(
      (c) => c.isAlive || !skipDead.shouldSkip(c),
    );
    if (firstIndex == -1) {
      _setActiveCombatantIndex(0);
      notifyListeners();
      await _update(_encounter.copyWith(
        round: _round,
        turn: _activeCombatantIndex,
      ));
      return;
    }

    _setActiveCombatantIndex(firstIndex);
    notifyListeners();
    await _update(_encounter.copyWith(
      round: _round,
      turn: _activeCombatantIndex,
    ));
  }

  Future<void> previousRound() async {
    if (!isPlaying) {
      return;
    }
    if (_round == 1) {
      return;
    }
    _round--;
    _setActiveCombatantIndex(_activeCombatantIndex);
    notifyListeners();
    await _update(_encounter.copyWith(
      round: _round,
      turn: _activeCombatantIndex,
    ));
  }

  Future<void> nextTurn() async {
    if (!isPlaying) {
      return;
    }

    _activeCombatantIndex++;
    if (_activeCombatantIndex >= _encounter.combatants.length) {
      return await nextRound();
    }

    final skipDeadBehavior = _settings.skipDeadBehavior;

    while (_activeCombatantIndex < _encounter.combatants.length) {
      final combatant = _encounter.combatants[_activeCombatantIndex];
      final skipIfDead = skipDeadBehavior.shouldSkip(combatant);
      if (combatant.isAlive || !skipIfDead) {
        _setActiveCombatantIndex(_activeCombatantIndex);
        notifyListeners();
        await _update(_encounter.copyWith(
          round: _round,
          turn: _activeCombatantIndex,
        ));
        return;
      }
      _activeCombatantIndex++;
    }
    // Reached the end of the list, go to the next round
    return nextRound();
  }

  Future<void> previousTurn() async {
    if (!isPlaying) {
      return;
    }
    int combatantIndex = _activeCombatantIndex;
    combatantIndex--;

    final skipDeadBehavior = _settings.skipDeadBehavior;
    while (combatantIndex >= 0) {
      final combatant = _encounter.combatants[combatantIndex];
      final skipIfDead = skipDeadBehavior.shouldSkip(combatant);
      if (combatant.isAlive || !skipIfDead) {
        _setActiveCombatantIndex(combatantIndex);
        notifyListeners();
        await _update(_encounter.copyWith(
          round: _round,
          turn: _activeCombatantIndex,
        ));
        return;
      }
      combatantIndex--;
    }

    // Reached the beginning of the list, go to the previous round
    if (round > 1) {
      final lastIndex = _encounter.combatants.lastIndexWhere(
        (c) => c.isAlive || !skipDeadBehavior.shouldSkip(c),
      );
      _activeCombatantIndex =
          lastIndex == -1 ? _encounter.combatants.length - 1 : lastIndex;
      return previousRound();
    }
  }
}
