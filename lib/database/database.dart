import 'package:battlemaster/database/database.steps.dart';
import 'package:battlemaster/database/tables.dart';
import 'package:battlemaster/features/encounters/models/encounter.dart';
import 'package:battlemaster/features/engines/models/game_engine_type.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';

import '../features/combatant/data/combatant_converter.dart';
import '../features/combatant/models/combatant.dart';
import '../features/encounters/models/encounter_type.dart';

part 'database.g.dart';

@DriftDatabase(tables: [EncounterTable, CustomConditions])
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
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: stepByStep(
        from1To2: (m, schema) async {
          m.createTable(customConditions);
        }),
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
                  ))
              .toList(),
        );
  }

  Future<Encounter> insertEncounter(Encounter encounter) async {
    final id = await into(encounterTable).insert(EncounterTableCompanion.insert(
      name: encounter.name,
      type: encounter.type,
      combatants: encounter.combatants,
      engine: encounter.engine.index,
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
      ),
    );
  }

  Future<void> eraseEncounters() async {
    await delete(encounterTable).go();
    await delete(customConditions).go();
  }
}
