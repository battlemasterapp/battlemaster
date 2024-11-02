import 'package:battlemaster/features/encounters/models/encounter_type.dart';
import 'package:flutter/material.dart';

import '../../../database/database.dart';
import '../models/encounter.dart';

class EncountersProvider extends ChangeNotifier {
  final AppDatabase _database;

  EncountersProvider(AppDatabase database):_database = database;

  Stream<List<Encounter>> watchEncounters() =>
      _database.watchEncounters(EncounterType.encounter);

  Stream<List<Encounter>> watchGroups() =>
      _database.watchEncounters(EncounterType.group);

  Future<Encounter> addEncounter(Encounter encounter) async {
    final created = await _database.insertEncounter(encounter);
    notifyListeners();
    return created;
  }

  Future<void> convertEncounterType(Encounter encounter) async {
    final updated = encounter.copyWith(
      type: encounter.type == EncounterType.encounter
          ? EncounterType.group
          : EncounterType.encounter,
    );
    await _database.updateEncounter(updated);
    notifyListeners();
  }

  Future<void> removeEncounter(Encounter encounter) async {
    await (_database.delete(_database.encounterTable)
          ..where((e) => e.id.equals(encounter.id)))
        .go();
    notifyListeners();
  }
}
