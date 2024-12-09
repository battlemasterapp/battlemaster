// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $EncounterTableTable extends EncounterTable
    with TableInfo<$EncounterTableTable, EncounterTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EncounterTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumnWithTypeConverter<EncounterType, int> type =
      GeneratedColumn<int>('type', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<EncounterType>($EncounterTableTable.$convertertype);
  static const VerificationMeta _combatantsMeta =
      const VerificationMeta('combatants');
  @override
  late final GeneratedColumnWithTypeConverter<List<Combatant>, String>
      combatants = GeneratedColumn<String>('combatants', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<Combatant>>(
              $EncounterTableTable.$convertercombatants);
  static const VerificationMeta _engineMeta = const VerificationMeta('engine');
  @override
  late final GeneratedColumn<int> engine = GeneratedColumn<int>(
      'engine', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _roundMeta = const VerificationMeta('round');
  @override
  late final GeneratedColumn<int> round = GeneratedColumn<int>(
      'round', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _turnMeta = const VerificationMeta('turn');
  @override
  late final GeneratedColumn<int> turn = GeneratedColumn<int>(
      'turn', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _logsMeta = const VerificationMeta('logs');
  @override
  late final GeneratedColumnWithTypeConverter<List<EncounterLog>, String> logs =
      GeneratedColumn<String>('logs', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('[]'))
          .withConverter<List<EncounterLog>>(
              $EncounterTableTable.$converterlogs);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, type, combatants, engine, round, turn, logs];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'encounter_table';
  @override
  VerificationContext validateIntegrity(Insertable<EncounterTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    context.handle(_typeMeta, const VerificationResult.success());
    context.handle(_combatantsMeta, const VerificationResult.success());
    if (data.containsKey('engine')) {
      context.handle(_engineMeta,
          engine.isAcceptableOrUnknown(data['engine']!, _engineMeta));
    } else if (isInserting) {
      context.missing(_engineMeta);
    }
    if (data.containsKey('round')) {
      context.handle(
          _roundMeta, round.isAcceptableOrUnknown(data['round']!, _roundMeta));
    }
    if (data.containsKey('turn')) {
      context.handle(
          _turnMeta, turn.isAcceptableOrUnknown(data['turn']!, _turnMeta));
    }
    context.handle(_logsMeta, const VerificationResult.success());
    return context;
  }

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
      type: $EncounterTableTable.$convertertype.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!),
      combatants: $EncounterTableTable.$convertercombatants.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}combatants'])!),
      engine: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}engine'])!,
      round: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}round'])!,
      turn: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}turn'])!,
      logs: $EncounterTableTable.$converterlogs.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logs'])!),
    );
  }

  @override
  $EncounterTableTable createAlias(String alias) {
    return $EncounterTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EncounterType, int, int> $convertertype =
      const EnumIndexConverter<EncounterType>(EncounterType.values);
  static JsonTypeConverter2<List<Combatant>, String, String>
      $convertercombatants = const CombatantsConverter();
  static JsonTypeConverter2<List<EncounterLog>, String, String> $converterlogs =
      const EncounterLogConverter();
}

class EncounterTableData extends DataClass
    implements Insertable<EncounterTableData> {
  final int id;
  final String name;
  final EncounterType type;
  final List<Combatant> combatants;
  final int engine;
  final int round;
  final int turn;
  final List<EncounterLog> logs;
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
    {
      map['type'] =
          Variable<int>($EncounterTableTable.$convertertype.toSql(type));
    }
    {
      map['combatants'] = Variable<String>(
          $EncounterTableTable.$convertercombatants.toSql(combatants));
    }
    map['engine'] = Variable<int>(engine);
    map['round'] = Variable<int>(round);
    map['turn'] = Variable<int>(turn);
    {
      map['logs'] =
          Variable<String>($EncounterTableTable.$converterlogs.toSql(logs));
    }
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
      type: $EncounterTableTable.$convertertype
          .fromJson(serializer.fromJson<int>(json['type'])),
      combatants: $EncounterTableTable.$convertercombatants
          .fromJson(serializer.fromJson<String>(json['combatants'])),
      engine: serializer.fromJson<int>(json['engine']),
      round: serializer.fromJson<int>(json['round']),
      turn: serializer.fromJson<int>(json['turn']),
      logs: $EncounterTableTable.$converterlogs
          .fromJson(serializer.fromJson<String>(json['logs'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer
          .toJson<int>($EncounterTableTable.$convertertype.toJson(type)),
      'combatants': serializer.toJson<String>(
          $EncounterTableTable.$convertercombatants.toJson(combatants)),
      'engine': serializer.toJson<int>(engine),
      'round': serializer.toJson<int>(round),
      'turn': serializer.toJson<int>(turn),
      'logs': serializer
          .toJson<String>($EncounterTableTable.$converterlogs.toJson(logs)),
    };
  }

  EncounterTableData copyWith(
          {int? id,
          String? name,
          EncounterType? type,
          List<Combatant>? combatants,
          int? engine,
          int? round,
          int? turn,
          List<EncounterLog>? logs}) =>
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
  final Value<EncounterType> type;
  final Value<List<Combatant>> combatants;
  final Value<int> engine;
  final Value<int> round;
  final Value<int> turn;
  final Value<List<EncounterLog>> logs;
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
    required EncounterType type,
    required List<Combatant> combatants,
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
      Value<EncounterType>? type,
      Value<List<Combatant>>? combatants,
      Value<int>? engine,
      Value<int>? round,
      Value<int>? turn,
      Value<List<EncounterLog>>? logs}) {
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
      map['type'] =
          Variable<int>($EncounterTableTable.$convertertype.toSql(type.value));
    }
    if (combatants.present) {
      map['combatants'] = Variable<String>(
          $EncounterTableTable.$convertercombatants.toSql(combatants.value));
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
      map['logs'] = Variable<String>(
          $EncounterTableTable.$converterlogs.toSql(logs.value));
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

class $CustomConditionsTable extends CustomConditions
    with TableInfo<$CustomConditionsTable, CustomCondition> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomConditionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _engineMeta = const VerificationMeta('engine');
  @override
  late final GeneratedColumnWithTypeConverter<GameEngineType, int> engine =
      GeneratedColumn<int>('engine', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<GameEngineType>(
              $CustomConditionsTable.$converterengine);
  @override
  List<GeneratedColumn> get $columns => [id, name, description, engine];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_conditions';
  @override
  VerificationContext validateIntegrity(Insertable<CustomCondition> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    context.handle(_engineMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomCondition map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomCondition(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      engine: $CustomConditionsTable.$converterengine.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}engine'])!),
    );
  }

  @override
  $CustomConditionsTable createAlias(String alias) {
    return $CustomConditionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<GameEngineType, int, int> $converterengine =
      const EnumIndexConverter<GameEngineType>(GameEngineType.values);
}

class CustomCondition extends DataClass implements Insertable<CustomCondition> {
  final int id;
  final String name;
  final String description;
  final GameEngineType engine;
  const CustomCondition(
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
    {
      map['engine'] =
          Variable<int>($CustomConditionsTable.$converterengine.toSql(engine));
    }
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

  factory CustomCondition.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomCondition(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      engine: $CustomConditionsTable.$converterengine
          .fromJson(serializer.fromJson<int>(json['engine'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'engine': serializer
          .toJson<int>($CustomConditionsTable.$converterengine.toJson(engine)),
    };
  }

  CustomCondition copyWith(
          {int? id,
          String? name,
          String? description,
          GameEngineType? engine}) =>
      CustomCondition(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        engine: engine ?? this.engine,
      );
  CustomCondition copyWithCompanion(CustomConditionsCompanion data) {
    return CustomCondition(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      engine: data.engine.present ? data.engine.value : this.engine,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomCondition(')
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
      (other is CustomCondition &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.engine == this.engine);
}

class CustomConditionsCompanion extends UpdateCompanion<CustomCondition> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> description;
  final Value<GameEngineType> engine;
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
    required GameEngineType engine,
  })  : name = Value(name),
        description = Value(description),
        engine = Value(engine);
  static Insertable<CustomCondition> custom({
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
      Value<GameEngineType>? engine}) {
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
      map['engine'] = Variable<int>(
          $CustomConditionsTable.$converterengine.toSql(engine.value));
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EncounterTableTable encounterTable = $EncounterTableTable(this);
  late final $CustomConditionsTable customConditions =
      $CustomConditionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [encounterTable, customConditions];
}

typedef $$EncounterTableTableCreateCompanionBuilder = EncounterTableCompanion
    Function({
  Value<int> id,
  required String name,
  required EncounterType type,
  required List<Combatant> combatants,
  required int engine,
  Value<int> round,
  Value<int> turn,
  Value<List<EncounterLog>> logs,
});
typedef $$EncounterTableTableUpdateCompanionBuilder = EncounterTableCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<EncounterType> type,
  Value<List<Combatant>> combatants,
  Value<int> engine,
  Value<int> round,
  Value<int> turn,
  Value<List<EncounterLog>> logs,
});

class $$EncounterTableTableFilterComposer
    extends Composer<_$AppDatabase, $EncounterTableTable> {
  $$EncounterTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<EncounterType, EncounterType, int> get type =>
      $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<List<Combatant>, List<Combatant>, String>
      get combatants => $composableBuilder(
          column: $table.combatants,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get engine => $composableBuilder(
      column: $table.engine, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get round => $composableBuilder(
      column: $table.round, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get turn => $composableBuilder(
      column: $table.turn, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<EncounterLog>, List<EncounterLog>, String>
      get logs => $composableBuilder(
          column: $table.logs,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$EncounterTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EncounterTableTable> {
  $$EncounterTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get combatants => $composableBuilder(
      column: $table.combatants, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get engine => $composableBuilder(
      column: $table.engine, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get round => $composableBuilder(
      column: $table.round, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get turn => $composableBuilder(
      column: $table.turn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get logs => $composableBuilder(
      column: $table.logs, builder: (column) => ColumnOrderings(column));
}

class $$EncounterTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EncounterTableTable> {
  $$EncounterTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EncounterType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<Combatant>, String> get combatants =>
      $composableBuilder(
          column: $table.combatants, builder: (column) => column);

  GeneratedColumn<int> get engine =>
      $composableBuilder(column: $table.engine, builder: (column) => column);

  GeneratedColumn<int> get round =>
      $composableBuilder(column: $table.round, builder: (column) => column);

  GeneratedColumn<int> get turn =>
      $composableBuilder(column: $table.turn, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<EncounterLog>, String> get logs =>
      $composableBuilder(column: $table.logs, builder: (column) => column);
}

class $$EncounterTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EncounterTableTable,
    EncounterTableData,
    $$EncounterTableTableFilterComposer,
    $$EncounterTableTableOrderingComposer,
    $$EncounterTableTableAnnotationComposer,
    $$EncounterTableTableCreateCompanionBuilder,
    $$EncounterTableTableUpdateCompanionBuilder,
    (
      EncounterTableData,
      BaseReferences<_$AppDatabase, $EncounterTableTable, EncounterTableData>
    ),
    EncounterTableData,
    PrefetchHooks Function()> {
  $$EncounterTableTableTableManager(
      _$AppDatabase db, $EncounterTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EncounterTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EncounterTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EncounterTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<EncounterType> type = const Value.absent(),
            Value<List<Combatant>> combatants = const Value.absent(),
            Value<int> engine = const Value.absent(),
            Value<int> round = const Value.absent(),
            Value<int> turn = const Value.absent(),
            Value<List<EncounterLog>> logs = const Value.absent(),
          }) =>
              EncounterTableCompanion(
            id: id,
            name: name,
            type: type,
            combatants: combatants,
            engine: engine,
            round: round,
            turn: turn,
            logs: logs,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required EncounterType type,
            required List<Combatant> combatants,
            required int engine,
            Value<int> round = const Value.absent(),
            Value<int> turn = const Value.absent(),
            Value<List<EncounterLog>> logs = const Value.absent(),
          }) =>
              EncounterTableCompanion.insert(
            id: id,
            name: name,
            type: type,
            combatants: combatants,
            engine: engine,
            round: round,
            turn: turn,
            logs: logs,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EncounterTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EncounterTableTable,
    EncounterTableData,
    $$EncounterTableTableFilterComposer,
    $$EncounterTableTableOrderingComposer,
    $$EncounterTableTableAnnotationComposer,
    $$EncounterTableTableCreateCompanionBuilder,
    $$EncounterTableTableUpdateCompanionBuilder,
    (
      EncounterTableData,
      BaseReferences<_$AppDatabase, $EncounterTableTable, EncounterTableData>
    ),
    EncounterTableData,
    PrefetchHooks Function()>;
typedef $$CustomConditionsTableCreateCompanionBuilder
    = CustomConditionsCompanion Function({
  Value<int> id,
  required String name,
  required String description,
  required GameEngineType engine,
});
typedef $$CustomConditionsTableUpdateCompanionBuilder
    = CustomConditionsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> description,
  Value<GameEngineType> engine,
});

class $$CustomConditionsTableFilterComposer
    extends Composer<_$AppDatabase, $CustomConditionsTable> {
  $$CustomConditionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<GameEngineType, GameEngineType, int>
      get engine => $composableBuilder(
          column: $table.engine,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$CustomConditionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomConditionsTable> {
  $$CustomConditionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get engine => $composableBuilder(
      column: $table.engine, builder: (column) => ColumnOrderings(column));
}

class $$CustomConditionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomConditionsTable> {
  $$CustomConditionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumnWithTypeConverter<GameEngineType, int> get engine =>
      $composableBuilder(column: $table.engine, builder: (column) => column);
}

class $$CustomConditionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CustomConditionsTable,
    CustomCondition,
    $$CustomConditionsTableFilterComposer,
    $$CustomConditionsTableOrderingComposer,
    $$CustomConditionsTableAnnotationComposer,
    $$CustomConditionsTableCreateCompanionBuilder,
    $$CustomConditionsTableUpdateCompanionBuilder,
    (
      CustomCondition,
      BaseReferences<_$AppDatabase, $CustomConditionsTable, CustomCondition>
    ),
    CustomCondition,
    PrefetchHooks Function()> {
  $$CustomConditionsTableTableManager(
      _$AppDatabase db, $CustomConditionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomConditionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomConditionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomConditionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<GameEngineType> engine = const Value.absent(),
          }) =>
              CustomConditionsCompanion(
            id: id,
            name: name,
            description: description,
            engine: engine,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String description,
            required GameEngineType engine,
          }) =>
              CustomConditionsCompanion.insert(
            id: id,
            name: name,
            description: description,
            engine: engine,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CustomConditionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CustomConditionsTable,
    CustomCondition,
    $$CustomConditionsTableFilterComposer,
    $$CustomConditionsTableOrderingComposer,
    $$CustomConditionsTableAnnotationComposer,
    $$CustomConditionsTableCreateCompanionBuilder,
    $$CustomConditionsTableUpdateCompanionBuilder,
    (
      CustomCondition,
      BaseReferences<_$AppDatabase, $CustomConditionsTable, CustomCondition>
    ),
    CustomCondition,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EncounterTableTableTableManager get encounterTable =>
      $$EncounterTableTableTableManager(_db, _db.encounterTable);
  $$CustomConditionsTableTableManager get customConditions =>
      $$CustomConditionsTableTableManager(_db, _db.customConditions);
}
