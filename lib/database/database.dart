import 'package:battlemaster/features/encounters/models/encounter.dart';
import 'package:battlemaster/features/engines/models/game_engine_type.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../features/combatant/data/combatant_converter.dart';
import '../features/combatant/models/combatant.dart';
import '../features/encounters/models/encounter_type.dart';

part 'database.g.dart';

class EncounterTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get round => integer()();
  IntColumn get type => intEnum<EncounterType>()();
  TextColumn get combatants => text().map(const CombatantsConverter())();
  IntColumn get engine => integer()();
}

@DriftDatabase(tables: [EncounterTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    // driftDatabase from package:drift_flutter stores the database in
    // getApplicationDocumentsDirectory().
    return driftDatabase(name: 'battlemaster');
  }

  Future<Encounter> insertEncounter(Encounter encounter) async {
    final id = await into(encounterTable).insert(EncounterTableCompanion.insert(
      name: encounter.name,
      round: encounter.round,
      type: encounter.type,
      combatants: encounter.combatants,
      engine: encounter.engine.index,
    ));
    return Encounter.fromJson(encounter.toJson()..['id'] = id);
  }

  Stream<List<Encounter>> watchAllEncounters() {
    return select(encounterTable).watch().asyncMap(
          (rows) =>
              rows.map((row) => Encounter(
                id: row.id,
                name: row.name,
                round: row.round,
                type: row.type,
                combatants: row.combatants,
                engine: GameEngineType.values[row.engine],
              )).toList(),
        );
  }
}
