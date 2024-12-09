// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
//@dart=2.12
import 'package:drift/drift.dart';

class EncounterTable extends Table
    with TableInfo<EncounterTable, EncounterTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  EncounterTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
      'type', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<String> combatants = GeneratedColumn<String>(
      'combatants', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> engine = GeneratedColumn<int>(
      'engine', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<int> round = GeneratedColumn<int>(
      'round', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  late final GeneratedColumn<int> turn = GeneratedColumn<int>(
      'turn', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  late final GeneratedColumn<String> logs = GeneratedColumn<String>(
      'logs', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, type, combatants, engine, round, turn, logs];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'encounter_table';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EncounterTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EncounterTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!,
      combatants: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}combatants'])!,
      engine: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}engine'])!,
      round: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}round'])!,
      turn: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}turn'])!,
      logs: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logs'])!,
    );
  }

  @override
  EncounterTable createAlias(String alias) {
    return EncounterTable(attachedDatabase, alias);
  }
}

class EncounterTableData extends DataClass
    implements Insertable<EncounterTableData> {
  final int id;
  final String name;
  final int type;
  final String combatants;
  final int engine;
  final int round;
  final int turn;
  final String logs;
  const EncounterTableData(
      {required this.id,
      required this.name,
      required this.type,
      required this.combatants,
      required this.engine,
      required this.round,
      required this.turn,
      required this.logs});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<int>(type);
    map['combatants'] = Variable<String>(combatants);
    map['engine'] = Variable<int>(engine);
    map['round'] = Variable<int>(round);
    map['turn'] = Variable<int>(turn);
    map['logs'] = Variable<String>(logs);
    return map;
  }

  EncounterTableCompanion toCompanion(bool nullToAbsent) {
    return EncounterTableCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      combatants: Value(combatants),
      engine: Value(engine),
      round: Value(round),
      turn: Value(turn),
      logs: Value(logs),
    );
  }

  factory EncounterTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EncounterTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<int>(json['type']),
      combatants: serializer.fromJson<String>(json['combatants']),
      engine: serializer.fromJson<int>(json['engine']),
      round: serializer.fromJson<int>(json['round']),
      turn: serializer.fromJson<int>(json['turn']),
      logs: serializer.fromJson<String>(json['logs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<int>(type),
      'combatants': serializer.toJson<String>(combatants),
      'engine': serializer.toJson<int>(engine),
      'round': serializer.toJson<int>(round),
      'turn': serializer.toJson<int>(turn),
      'logs': serializer.toJson<String>(logs),
    };
  }

  EncounterTableData copyWith(
          {int? id,
          String? name,
          int? type,
          String? combatants,
          int? engine,
          int? round,
          int? turn,
          String? logs}) =>
      EncounterTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        combatants: combatants ?? this.combatants,
        engine: engine ?? this.engine,
        round: round ?? this.round,
        turn: turn ?? this.turn,
        logs: logs ?? this.logs,
      );
  EncounterTableData copyWithCompanion(EncounterTableCompanion data) {
    return EncounterTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      combatants:
          data.combatants.present ? data.combatants.value : this.combatants,
      engine: data.engine.present ? data.engine.value : this.engine,
      round: data.round.present ? data.round.value : this.round,
      turn: data.turn.present ? data.turn.value : this.turn,
      logs: data.logs.present ? data.logs.value : this.logs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EncounterTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('combatants: $combatants, ')
          ..write('engine: $engine, ')
          ..write('round: $round, ')
          ..write('turn: $turn, ')
          ..write('logs: $logs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, type, combatants, engine, round, turn, logs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EncounterTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.combatants == this.combatants &&
          other.engine == this.engine &&
          other.round == this.round &&
          other.turn == this.turn &&
          other.logs == this.logs);
}

class EncounterTableCompanion extends UpdateCompanion<EncounterTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> type;
  final Value<String> combatants;
  final Value<int> engine;
  final Value<int> round;
  final Value<int> turn;
  final Value<String> logs;
  const EncounterTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.combatants = const Value.absent(),
    this.engine = const Value.absent(),
    this.round = const Value.absent(),
    this.turn = const Value.absent(),
    this.logs = const Value.absent(),
  });
  EncounterTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int type,
    required String combatants,
    required int engine,
    this.round = const Value.absent(),
    this.turn = const Value.absent(),
    this.logs = const Value.absent(),
  })  : name = Value(name),
        type = Value(type),
        combatants = Value(combatants),
        engine = Value(engine);
  static Insertable<EncounterTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? type,
    Expression<String>? combatants,
    Expression<int>? engine,
    Expression<int>? round,
    Expression<int>? turn,
    Expression<String>? logs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (combatants != null) 'combatants': combatants,
      if (engine != null) 'engine': engine,
      if (round != null) 'round': round,
      if (turn != null) 'turn': turn,
      if (logs != null) 'logs': logs,
    });
  }

  EncounterTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? type,
      Value<String>? combatants,
      Value<int>? engine,
      Value<int>? round,
      Value<int>? turn,
      Value<String>? logs}) {
    return EncounterTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      combatants: combatants ?? this.combatants,
      engine: engine ?? this.engine,
      round: round ?? this.round,
      turn: turn ?? this.turn,
      logs: logs ?? this.logs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (combatants.present) {
      map['combatants'] = Variable<String>(combatants.value);
    }
    if (engine.present) {
      map['engine'] = Variable<int>(engine.value);
    }
    if (round.present) {
      map['round'] = Variable<int>(round.value);
    }
    if (turn.present) {
      map['turn'] = Variable<int>(turn.value);
    }
    if (logs.present) {
      map['logs'] = Variable<String>(logs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EncounterTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('combatants: $combatants, ')
          ..write('engine: $engine, ')
          ..write('round: $round, ')
          ..write('turn: $turn, ')
          ..write('logs: $logs')
          ..write(')'))
        .toString();
  }
}

class CustomConditions extends Table
    with TableInfo<CustomConditions, CustomConditionsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  CustomConditions(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> engine = GeneratedColumn<int>(
      'engine', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, description, engine];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_conditions';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomConditionsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomConditionsData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      engine: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}engine'])!,
    );
  }

  @override
  CustomConditions createAlias(String alias) {
    return CustomConditions(attachedDatabase, alias);
  }
}

class CustomConditionsData extends DataClass
    implements Insertable<CustomConditionsData> {
  final int id;
  final String name;
  final String description;
  final int engine;
  const CustomConditionsData(
      {required this.id,
      required this.name,
      required this.description,
      required this.engine});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['engine'] = Variable<int>(engine);
    return map;
  }

  CustomConditionsCompanion toCompanion(bool nullToAbsent) {
    return CustomConditionsCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      engine: Value(engine),
    );
  }

  factory CustomConditionsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomConditionsData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      engine: serializer.fromJson<int>(json['engine']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'engine': serializer.toJson<int>(engine),
    };
  }

  CustomConditionsData copyWith(
          {int? id, String? name, String? description, int? engine}) =>
      CustomConditionsData(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        engine: engine ?? this.engine,
      );
  CustomConditionsData copyWithCompanion(CustomConditionsCompanion data) {
    return CustomConditionsData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      engine: data.engine.present ? data.engine.value : this.engine,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomConditionsData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('engine: $engine')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, engine);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomConditionsData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.engine == this.engine);
}

class CustomConditionsCompanion extends UpdateCompanion<CustomConditionsData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> description;
  final Value<int> engine;
  const CustomConditionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.engine = const Value.absent(),
  });
  CustomConditionsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String description,
    required int engine,
  })  : name = Value(name),
        description = Value(description),
        engine = Value(engine);
  static Insertable<CustomConditionsData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? engine,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (engine != null) 'engine': engine,
    });
  }

  CustomConditionsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? description,
      Value<int>? engine}) {
    return CustomConditionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      engine: engine ?? this.engine,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (engine.present) {
      map['engine'] = Variable<int>(engine.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomConditionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('engine: $engine')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV3 extends GeneratedDatabase {
  DatabaseAtV3(QueryExecutor e) : super(e);
  late final EncounterTable encounterTable = EncounterTable(this);
  late final CustomConditions customConditions = CustomConditions(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [encounterTable, customConditions];
  @override
  int get schemaVersion => 3;
}
