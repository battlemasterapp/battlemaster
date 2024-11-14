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
  @override
  List<GeneratedColumn> get $columns => [id, name, type, combatants, engine];
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
  const EncounterTableData(
      {required this.id,
      required this.name,
      required this.type,
      required this.combatants,
      required this.engine});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<int>(type);
    map['combatants'] = Variable<String>(combatants);
    map['engine'] = Variable<int>(engine);
    return map;
  }

  EncounterTableCompanion toCompanion(bool nullToAbsent) {
    return EncounterTableCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      combatants: Value(combatants),
      engine: Value(engine),
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
    };
  }

  EncounterTableData copyWith(
          {int? id,
          String? name,
          int? type,
          String? combatants,
          int? engine}) =>
      EncounterTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        combatants: combatants ?? this.combatants,
        engine: engine ?? this.engine,
      );
  EncounterTableData copyWithCompanion(EncounterTableCompanion data) {
    return EncounterTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      combatants:
          data.combatants.present ? data.combatants.value : this.combatants,
      engine: data.engine.present ? data.engine.value : this.engine,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EncounterTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('combatants: $combatants, ')
          ..write('engine: $engine')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, combatants, engine);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EncounterTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.combatants == this.combatants &&
          other.engine == this.engine);
}

class EncounterTableCompanion extends UpdateCompanion<EncounterTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> type;
  final Value<String> combatants;
  final Value<int> engine;
  const EncounterTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.combatants = const Value.absent(),
    this.engine = const Value.absent(),
  });
  EncounterTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int type,
    required String combatants,
    required int engine,
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
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (combatants != null) 'combatants': combatants,
      if (engine != null) 'engine': engine,
    });
  }

  EncounterTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? type,
      Value<String>? combatants,
      Value<int>? engine}) {
    return EncounterTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      combatants: combatants ?? this.combatants,
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
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (combatants.present) {
      map['combatants'] = Variable<String>(combatants.value);
    }
    if (engine.present) {
      map['engine'] = Variable<int>(engine.value);
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
          ..write('engine: $engine')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV1 extends GeneratedDatabase {
  DatabaseAtV1(QueryExecutor e) : super(e);
  late final EncounterTable encounterTable = EncounterTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [encounterTable];
  @override
  int get schemaVersion => 1;
}
