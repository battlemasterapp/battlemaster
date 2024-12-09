import 'package:battlemaster/features/combatant/data/combatant_converter.dart';
import 'package:battlemaster/features/encounters/models/encounter_type.dart';
import 'package:battlemaster/features/engines/models/game_engine_type.dart';
import 'package:drift/drift.dart';

class EncounterTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get type => intEnum<EncounterType>()();
  TextColumn get combatants => text().map(const CombatantsConverter())();
  IntColumn get engine => integer()();
}

class CustomConditions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  IntColumn get engine => intEnum<GameEngineType>()();
}
