import 'package:battlemaster/features/conditions/models/condition.dart';
import 'package:battlemaster/features/encounters/models/encounter_log.dart';
import 'package:battlemaster/features/encounters/models/encounter_type.dart';
import 'package:flutter/material.dart';
import 'package:nanoid2/nanoid2.dart';

import '../../../database/database.dart';
import '../../combatant/models/combatant.dart';
import '../models/encounter.dart';

class EncountersProvider extends ChangeNotifier {
  final AppDatabase _database;

  EncountersProvider(AppDatabase database) : _database = database;

  Stream<List<Encounter>> watchEncounters(EncounterType type) =>
      _database.watchEncounters(type);

  Future<Encounter> addEncounter(Encounter encounter) async {
    final created = await _database.insertEncounter(encounter);
    return created;
  }

  Future<void> convertEncounterType(Encounter encounter) async {
    final updated = encounter.copyWith(
      type: encounter.type == EncounterType.encounter
          ? EncounterType.group
          : EncounterType.encounter,
    );
    await _database.updateEncounter(updated);
  }

  Future<void> updateCombatantInitiative(
    Encounter encounter,
    Combatant combatant,
    double initiative,
  ) async {
    final log = CombatantInitiativeLog(
      round: encounter.round,
      turn: encounter.turn,
      combatant: combatant,
      initiative: initiative,
    );

    final updated = log.apply(encounter);
    await _database.updateEncounter(updated);
  }

  Future<void> updateCombatantHealth(
    Encounter encounter,
    Combatant combatant,
    int health,
  ) async {
    final damage = combatant.currentHp - health;
    if (damage == 0) {
      return;
    }

    final log = DamageCombatantLog(
      round: encounter.round,
      turn: encounter.turn,
      combatant: combatant,
      damage: damage,
    );

    final updated = log.apply(encounter);
    await _database.updateEncounter(updated);
  }

  Future<void> updateCombatantsConditions(
    Encounter encounter,
    Combatant combatant,
    List<Condition> conditions,
  ) async {
    final log = AddConditionsLog(
      round: encounter.round,
      turn: encounter.turn,
      combatant: combatant,
      conditions: conditions,
    );

    final updated = log.apply(encounter);
    await _database.updateEncounter(updated);
  }

  Future<void> addCombatants(
    Encounter encounter,
    Map<Combatant, int> combatantsMap,
  ) async {
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
              round: encounter.round,
              turn: encounter.turn,
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
      encounter,
      (e, log) => log.apply(e),
    );
    await _database.updateEncounter(updated);
  }

  Future<void> removeCombatant(Encounter encounter, Combatant combatant) async {
    final removeLog = RemoveCombatantLog(
      round: encounter.round,
      turn: encounter.turn,
      combatant: combatant,
    );
    final updated = removeLog.apply(encounter);
    await _database.updateEncounter(updated);
  }

  Future<void> removeEncounter(Encounter encounter) async {
    await (_database.delete(_database.encounterTable)
          ..where((e) => e.id.equals(encounter.id)))
        .go();
  }

  Future<void> deleteHistory(Encounter encounter) async {
    final updated = encounter.copyWith(logs: []);
    await _database.updateEncounter(updated);
  }

  Future<void> undoLog(Encounter encounter, EncounterLog log) async {
    final updated = log.undo(encounter).copyWith(
          logs: encounter.logs..remove(log),
        );
    await _database.updateEncounter(updated);
  }
}
