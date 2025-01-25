import 'package:battlemaster/features/encounters/models/encounter_type.dart';
import 'package:battlemaster/features/sync/providers/sync_encounter_repository.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../database/database.dart';
import '../models/encounter.dart';

class EncountersProvider extends ChangeNotifier {
  final AppDatabase _database;
  SyncEncounterRepository _encounterRepository;
  final _logger = Logger();

  EncountersProvider(
    AppDatabase database,
    SyncEncounterRepository encounterRepo,
  )   : _database = database,
        _encounterRepository = encounterRepo;

  set encounterRepo(SyncEncounterRepository repo) {
    _encounterRepository = repo;
  }

  Stream<List<Encounter>> watchEncounters(EncounterType type) =>
      _database.watchEncounters(type);

  Future<Encounter> createEncounter(Encounter encounter) async {
    final created = await _database.insertEncounter(encounter);
    final syncId = await _encounterRepository.upsertEncounter(created);
    if (syncId != null) {
      final syncedEncounter = created.copyWith(syncId: syncId);
      await _database.updateEncounter(syncedEncounter);
      return syncedEncounter;
    }
    return created;
  }

  Future<void> syncAllEncounters() async {
    final serverEncounters = await _encounterRepository.getEncounters();

    try {
      await Future.wait(
          serverEncounters.map((e) => _database.upsertEncounter(e)).toList());
    } catch (e) {
      _logger.e(e);
    }

    final encounters = await _database.getEncounters();
    await Future.wait(encounters
        .map(
          (e) async {
            final syncId = await _encounterRepository.upsertEncounter(e);
            if (syncId == null) {
              return;
            }
            if (e.syncId != null) {
              return;
            }
            await _database.updateEncounter(e.copyWith(syncId: syncId));
          },
        )
        .toList());
  }

  Future<void> convertEncounterType(Encounter encounter) async {
    final updated = encounter.copyWith(
      type: encounter.type == EncounterType.encounter
          ? EncounterType.group
          : EncounterType.encounter,
    );
    await _database.updateEncounter(updated);
    await _encounterRepository.upsertEncounter(updated);
  }

  Future<void> removeEncounter(Encounter encounter) async {
    await (_database.delete(_database.encounterTable)
          ..where((e) => e.id.equals(encounter.id)))
        .go();
    await _encounterRepository.deleteEncounter(encounter);
  }
}
