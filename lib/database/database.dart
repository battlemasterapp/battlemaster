import 'package:battlemaster/database/database.steps.dart';
import 'package:battlemaster/database/tables.dart';
import 'package:battlemaster/features/encounters/data/encounter_log_converter.dart';
import 'package:battlemaster/features/encounters/models/encounter.dart';
import 'package:battlemaster/features/engines/models/game_engine_type.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';

import '../features/combatant/data/combatant_converter.dart';
import '../features/combatant/models/combatant.dart';
import '../features/encounters/models/encounter_log.dart';
import '../features/encounters/models/encounter_type.dart';

part 'database.g.dart';

@DriftDatabase(tables: [EncounterTable, CustomConditions, CustomBestiaries])
class AppDatabase extends _$AppDatabase {
  AppDatabase({QueryExecutor? executor})
      : super(
          executor ??
              driftDatabase(
                name: 'battlemaster',
                web: DriftWebOptions(
                    sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                    driftWorker: Uri.parse('drift_worker.js'),
                    onResult: (result) {
                      if (result.missingFeatures.isNotEmpty) {
                        debugPrint(
                            'Using ${result.chosenImplementation} due to unsupported '
                            'browser features: ${result.missingFeatures}');
                      }
                    }),
              ),
        );

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: stepByStep(
        from1To2: (m, schema) async {
          await m.createTable(customConditions);
        },
        from2To3: (m, schema) async {
          await m.addColumn(encounterTable, encounterTable.round);
          await m.addColumn(encounterTable, encounterTable.turn);
          await m.addColumn(encounterTable, encounterTable.logs);
        },
        from3To4: (m, schema) async {
          await m.createTable(customBestiaries);
        },
      ),
    );
  }

  Stream<List<Encounter>> watchEncounters(EncounterType type) {
    return (select(encounterTable)..where((e) => e.type.equals(type.index)))
        .watch()
        .asyncMap(
          (rows) => rows
              .map((row) => Encounter(
                    id: row.id,
                    name: row.name,
                    type: row.type,
                    combatants: row.combatants,
                    engine: GameEngineType.values[row.engine],
                    round: row.round,
                    turn: row.turn,
                    logs: row.logs,
                  ))
              .toList(),
        );
  }

  Future<List<Encounter>> getEncounters() async {
    return (await select(encounterTable).get())
        .map((row) => Encounter(
              id: row.id,
              name: row.name,
              type: row.type,
              combatants: row.combatants,
              engine: GameEngineType.values[row.engine],
              round: row.round,
              turn: row.turn,
              logs: row.logs,
            ))
        .toList();
  }

  Future<Encounter> insertEncounter(Encounter encounter) async {
    final id = await into(encounterTable).insert(EncounterTableCompanion.insert(
      id: encounter.id > 0 ? Value(encounter.id) : Value.absent(),
      name: encounter.name,
      type: encounter.type,
      combatants: encounter.combatants,
      engine: encounter.engine.index,
      round: Value(encounter.round),
      turn: Value(encounter.turn),
      logs: Value(encounter.logs),
    ));
    return Encounter.fromJson(encounter.toJson()..['id'] = id);
  }

  Future<void> updateEncounter(Encounter encounter) async {
    await (update(encounterTable)..where((e) => e.id.equals(encounter.id)))
        .write(
      EncounterTableCompanion(
        id: Value(encounter.id),
        name: Value(encounter.name),
        type: Value(encounter.type),
        combatants: Value(encounter.combatants),
        engine: Value(encounter.engine.index),
        round: Value(encounter.round),
        turn: Value(encounter.turn),
        logs: Value(encounter.logs),
      ),
    );
  }

  Future<void> upsertEncounter(Encounter encounter) async {
    final existing = await (select(encounterTable)
          ..where((e) => e.id.equals(encounter.id)))
        .getSingleOrNull();
    if (existing != null) {
      return await updateEncounter(encounter);
    }
    await insertEncounter(encounter);
  }

  Stream<List<CustomCondition>> watchConditions() {
    return select(customConditions).watch().map((rows) => rows.toList());
  }

  Future<List<CustomCondition>> getConditions() {
    return select(customConditions).get();
  }

  Future<CustomCondition> insertCondition(CustomCondition condition) async {
    final id = await into(customConditions).insert(
      CustomConditionsCompanion.insert(
        name: condition.name,
        description: condition.description,
        engine: condition.engine,
      ),
    );
    return await (select(customConditions)..where((c) => c.id.equals(id)))
        .getSingle();
  }

  Future<void> updateCondition(CustomCondition condtion) async {
    await (update(customConditions)..where((c) => c.id.equals(condtion.id)))
        .write(
      CustomConditionsCompanion(
        id: Value(condtion.id),
        name: Value(condtion.name),
        description: Value(condtion.description),
        engine: Value(condtion.engine),
      ),
    );
  }

  Future<int> deleteCondition(CustomCondition condition) async {
    return await (delete(customConditions)
          ..where((c) => c.id.equals(condition.id)))
        .go();
  }

  Stream<List<CustomBestiary>> watchCustomBestiaries() {
    return select(customBestiaries).watch();
  }

  Future<void> insertBestiary(CustomBestiary bestiary) async {
    await into(customBestiaries).insert(
      CustomBestiariesCompanion.insert(
        name: bestiary.name,
        combatants: bestiary.combatants,
        engine: bestiary.engine,
      ),
    );
  }

  Future<void> deleteBestiary(int id) async {
    await (delete(customBestiaries)..where((b) => b.id.equals(id))).go();
  }

  Future<void> eraseDb() async {
    await delete(encounterTable).go();
    await delete(customConditions).go();
    await delete(customBestiaries).go();
  }
}
