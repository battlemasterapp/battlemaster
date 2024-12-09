import 'package:battlemaster/features/encounters/models/encounter_type.dart';
import 'package:flutter/material.dart';

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

  Future<void> editEncounterName(Encounter encounter, String name) async {
    await _database.updateEncounter(encounter.copyWith(name: name));
  }

  Future<void> editCombatant(
    Encounter encounter,
    Combatant combatant,
    int index,
  ) async {
    final combatants = encounter.combatants
      ..replaceRange(
        index,
        index + 1,
        [combatant],
      );
    final updated = encounter.copyWith(
      combatants: combatants
        ..sort(
          (a, b) => b.initiative.compareTo(a.initiative),
        ),
    );
    await _database.updateEncounter(updated);
  }

  Future<void> addCombatants(
    Encounter encounter,
    Map<Combatant, int> combatantsMap,
  ) async {
    if (combatantsMap.isEmpty) {
      return;
    }
    final combatants = combatantsMap.entries.fold<List<Combatant>>(
      [],
      (combatants, mapEntry) {
        return [
          ...combatants,
          ...List.generate(mapEntry.value, (index) => mapEntry.key),
        ];
      },
    );
    final updated = encounter.copyWith(
      combatants: [...encounter.combatants, ...combatants],
    );
    await _database.updateEncounter(updated);
  }

  Future<void> removeEncounter(Encounter encounter) async {
    await (_database.delete(_database.encounterTable)
          ..where((e) => e.id.equals(encounter.id)))
        .go();
  }
}
