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
  TextColumn get combatants => text().map(const CombatantConverter())();
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
    return driftDatabase(name: 'my_database');
  }
}
