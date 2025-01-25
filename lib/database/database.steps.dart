import 'package:drift/internal/versioned_schema.dart' as i0;
import 'package:drift/drift.dart' as i1;
import 'package:drift/drift.dart'; // ignore_for_file: type=lint,unused_import

// GENERATED BY drift_dev, DO NOT MODIFY.
final class Schema2 extends i0.VersionedSchema {
  Schema2({required super.database}) : super(version: 2);
  @override
  late final List<i1.DatabaseSchemaEntity> entities = [
    encounterTable,
    customConditions,
  ];
  late final Shape0 encounterTable = Shape0(
      source: i0.VersionedTable(
        entityName: 'encounter_table',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_1,
          _column_2,
          _column_3,
          _column_4,
        ],
        attachedDatabase: database,
      ),
      alias: null);
  late final Shape1 customConditions = Shape1(
      source: i0.VersionedTable(
        entityName: 'custom_conditions',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_1,
          _column_5,
          _column_4,
        ],
        attachedDatabase: database,
      ),
      alias: null);
}

class Shape0 extends i0.VersionedTable {
  Shape0({required super.source, required super.alias}) : super.aliased();
  i1.GeneratedColumn<int> get id =>
      columnsByName['id']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<String> get name =>
      columnsByName['name']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<int> get type =>
      columnsByName['type']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<String> get combatants =>
      columnsByName['combatants']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<int> get engine =>
      columnsByName['engine']! as i1.GeneratedColumn<int>;
}

i1.GeneratedColumn<int> _column_0(String aliasedName) =>
    i1.GeneratedColumn<int>('id', aliasedName, false,
        hasAutoIncrement: true,
        type: i1.DriftSqlType.int,
        defaultConstraints:
            i1.GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
i1.GeneratedColumn<String> _column_1(String aliasedName) =>
    i1.GeneratedColumn<String>('name', aliasedName, false,
        type: i1.DriftSqlType.string);
i1.GeneratedColumn<int> _column_2(String aliasedName) =>
    i1.GeneratedColumn<int>('type', aliasedName, false,
        type: i1.DriftSqlType.int);
i1.GeneratedColumn<String> _column_3(String aliasedName) =>
    i1.GeneratedColumn<String>('combatants', aliasedName, false,
        type: i1.DriftSqlType.string);
i1.GeneratedColumn<int> _column_4(String aliasedName) =>
    i1.GeneratedColumn<int>('engine', aliasedName, false,
        type: i1.DriftSqlType.int);

class Shape1 extends i0.VersionedTable {
  Shape1({required super.source, required super.alias}) : super.aliased();
  i1.GeneratedColumn<int> get id =>
      columnsByName['id']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<String> get name =>
      columnsByName['name']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<String> get description =>
      columnsByName['description']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<int> get engine =>
      columnsByName['engine']! as i1.GeneratedColumn<int>;
}

i1.GeneratedColumn<String> _column_5(String aliasedName) =>
    i1.GeneratedColumn<String>('description', aliasedName, false,
        type: i1.DriftSqlType.string);

final class Schema3 extends i0.VersionedSchema {
  Schema3({required super.database}) : super(version: 3);
  @override
  late final List<i1.DatabaseSchemaEntity> entities = [
    encounterTable,
    customConditions,
  ];
  late final Shape2 encounterTable = Shape2(
      source: i0.VersionedTable(
        entityName: 'encounter_table',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_1,
          _column_2,
          _column_3,
          _column_4,
          _column_6,
          _column_7,
          _column_8,
        ],
        attachedDatabase: database,
      ),
      alias: null);
  late final Shape1 customConditions = Shape1(
      source: i0.VersionedTable(
        entityName: 'custom_conditions',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_1,
          _column_5,
          _column_4,
        ],
        attachedDatabase: database,
      ),
      alias: null);
}

class Shape2 extends i0.VersionedTable {
  Shape2({required super.source, required super.alias}) : super.aliased();
  i1.GeneratedColumn<int> get id =>
      columnsByName['id']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<String> get name =>
      columnsByName['name']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<int> get type =>
      columnsByName['type']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<String> get combatants =>
      columnsByName['combatants']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<int> get engine =>
      columnsByName['engine']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<int> get round =>
      columnsByName['round']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<int> get turn =>
      columnsByName['turn']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<String> get logs =>
      columnsByName['logs']! as i1.GeneratedColumn<String>;
}

i1.GeneratedColumn<int> _column_6(String aliasedName) =>
    i1.GeneratedColumn<int>('round', aliasedName, false,
        type: i1.DriftSqlType.int, defaultValue: const Constant(1));
i1.GeneratedColumn<int> _column_7(String aliasedName) =>
    i1.GeneratedColumn<int>('turn', aliasedName, false,
        type: i1.DriftSqlType.int, defaultValue: const Constant(0));
i1.GeneratedColumn<String> _column_8(String aliasedName) =>
    i1.GeneratedColumn<String>('logs', aliasedName, false,
        type: i1.DriftSqlType.string, defaultValue: const Constant('[]'));

final class Schema4 extends i0.VersionedSchema {
  Schema4({required super.database}) : super(version: 4);
  @override
  late final List<i1.DatabaseSchemaEntity> entities = [
    encounterTable,
    customConditions,
    customBestiaries,
  ];
  late final Shape2 encounterTable = Shape2(
      source: i0.VersionedTable(
        entityName: 'encounter_table',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_1,
          _column_2,
          _column_3,
          _column_4,
          _column_6,
          _column_7,
          _column_8,
        ],
        attachedDatabase: database,
      ),
      alias: null);
  late final Shape1 customConditions = Shape1(
      source: i0.VersionedTable(
        entityName: 'custom_conditions',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_1,
          _column_5,
          _column_4,
        ],
        attachedDatabase: database,
      ),
      alias: null);
  late final Shape3 customBestiaries = Shape3(
      source: i0.VersionedTable(
        entityName: 'custom_bestiaries',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_1,
          _column_3,
          _column_4,
        ],
        attachedDatabase: database,
      ),
      alias: null);
}

class Shape3 extends i0.VersionedTable {
  Shape3({required super.source, required super.alias}) : super.aliased();
  i1.GeneratedColumn<int> get id =>
      columnsByName['id']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<String> get name =>
      columnsByName['name']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<String> get combatants =>
      columnsByName['combatants']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<int> get engine =>
      columnsByName['engine']! as i1.GeneratedColumn<int>;
}

final class Schema5 extends i0.VersionedSchema {
  Schema5({required super.database}) : super(version: 5);
  @override
  late final List<i1.DatabaseSchemaEntity> entities = [
    encounterTable,
    customConditions,
    customBestiaries,
  ];
  late final Shape4 encounterTable = Shape4(
      source: i0.VersionedTable(
        entityName: 'encounter_table',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_1,
          _column_2,
          _column_3,
          _column_4,
          _column_6,
          _column_7,
          _column_8,
          _column_9,
        ],
        attachedDatabase: database,
      ),
      alias: null);
  late final Shape1 customConditions = Shape1(
      source: i0.VersionedTable(
        entityName: 'custom_conditions',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_1,
          _column_5,
          _column_4,
        ],
        attachedDatabase: database,
      ),
      alias: null);
  late final Shape3 customBestiaries = Shape3(
      source: i0.VersionedTable(
        entityName: 'custom_bestiaries',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_1,
          _column_3,
          _column_4,
        ],
        attachedDatabase: database,
      ),
      alias: null);
}

class Shape4 extends i0.VersionedTable {
  Shape4({required super.source, required super.alias}) : super.aliased();
  i1.GeneratedColumn<int> get id =>
      columnsByName['id']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<String> get name =>
      columnsByName['name']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<int> get type =>
      columnsByName['type']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<String> get combatants =>
      columnsByName['combatants']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<int> get engine =>
      columnsByName['engine']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<int> get round =>
      columnsByName['round']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<int> get turn =>
      columnsByName['turn']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<String> get logs =>
      columnsByName['logs']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<String> get syncId =>
      columnsByName['sync_id']! as i1.GeneratedColumn<String>;
}

i1.GeneratedColumn<String> _column_9(String aliasedName) =>
    i1.GeneratedColumn<String>('sync_id', aliasedName, true,
        type: i1.DriftSqlType.string);
i0.MigrationStepWithVersion migrationSteps({
  required Future<void> Function(i1.Migrator m, Schema2 schema) from1To2,
  required Future<void> Function(i1.Migrator m, Schema3 schema) from2To3,
  required Future<void> Function(i1.Migrator m, Schema4 schema) from3To4,
  required Future<void> Function(i1.Migrator m, Schema5 schema) from4To5,
}) {
  return (currentVersion, database) async {
    switch (currentVersion) {
      case 1:
        final schema = Schema2(database: database);
        final migrator = i1.Migrator(database, schema);
        await from1To2(migrator, schema);
        return 2;
      case 2:
        final schema = Schema3(database: database);
        final migrator = i1.Migrator(database, schema);
        await from2To3(migrator, schema);
        return 3;
      case 3:
        final schema = Schema4(database: database);
        final migrator = i1.Migrator(database, schema);
        await from3To4(migrator, schema);
        return 4;
      case 4:
        final schema = Schema5(database: database);
        final migrator = i1.Migrator(database, schema);
        await from4To5(migrator, schema);
        return 5;
      default:
        throw ArgumentError.value('Unknown migration from $currentVersion');
    }
  };
}

i1.OnUpgrade stepByStep({
  required Future<void> Function(i1.Migrator m, Schema2 schema) from1To2,
  required Future<void> Function(i1.Migrator m, Schema3 schema) from2To3,
  required Future<void> Function(i1.Migrator m, Schema4 schema) from3To4,
  required Future<void> Function(i1.Migrator m, Schema5 schema) from4To5,
}) =>
    i0.VersionedSchema.stepByStepHelper(
        step: migrationSteps(
      from1To2: from1To2,
      from2To3: from2To3,
      from3To4: from3To4,
      from4To5: from4To5,
    ));
