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
  static const VerificationMeta _roundMeta = const VerificationMeta('round');
  @override
  late final GeneratedColumn<int> round = GeneratedColumn<int>(
      'round', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _combatantsMeta =
      const VerificationMeta('combatants');
  @override
  late final GeneratedColumnWithTypeConverter<Combatant, String> combatants =
      GeneratedColumn<String>('combatants', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Combatant>($EncounterTableTable.$convertercombatants);
  static const VerificationMeta _engineMeta = const VerificationMeta('engine');
  @override
  late final GeneratedColumn<int> engine = GeneratedColumn<int>(
      'engine', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, round, combatants, engine];
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
    if (data.containsKey('round')) {
      context.handle(
          _roundMeta, round.isAcceptableOrUnknown(data['round']!, _roundMeta));
    } else if (isInserting) {
      context.missing(_roundMeta);
    }
    context.handle(_combatantsMeta, const VerificationResult.success());
    if (data.containsKey('engine')) {
      context.handle(_engineMeta,
          engine.isAcceptableOrUnknown(data['engine']!, _engineMeta));
    } else if (isInserting) {
      context.missing(_engineMeta);
    }
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
      round: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}round'])!,
      combatants: $EncounterTableTable.$convertercombatants.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}combatants'])!),
      engine: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}engine'])!,
    );
  }

  @override
  $EncounterTableTable createAlias(String alias) {
    return $EncounterTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Combatant, String, String> $convertercombatants =
      const CombatantConverter();
}

class EncounterTableData extends DataClass
    implements Insertable<EncounterTableData> {
  final int id;
  final String name;
  final int round;
  final Combatant combatants;
  final int engine;
  const EncounterTableData(
      {required this.id,
      required this.name,
      required this.round,
      required this.combatants,
      required this.engine});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['round'] = Variable<int>(round);
    {
      map['combatants'] = Variable<String>(
          $EncounterTableTable.$convertercombatants.toSql(combatants));
    }
    map['engine'] = Variable<int>(engine);
    return map;
  }

  EncounterTableCompanion toCompanion(bool nullToAbsent) {
    return EncounterTableCompanion(
      id: Value(id),
      name: Value(name),
      round: Value(round),
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
      round: serializer.fromJson<int>(json['round']),
      combatants: $EncounterTableTable.$convertercombatants
          .fromJson(serializer.fromJson<String>(json['combatants'])),
      engine: serializer.fromJson<int>(json['engine']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'round': serializer.toJson<int>(round),
      'combatants': serializer.toJson<String>(
          $EncounterTableTable.$convertercombatants.toJson(combatants)),
      'engine': serializer.toJson<int>(engine),
    };
  }

  EncounterTableData copyWith(
          {int? id,
          String? name,
          int? round,
          Combatant? combatants,
          int? engine}) =>
      EncounterTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        round: round ?? this.round,
        combatants: combatants ?? this.combatants,
        engine: engine ?? this.engine,
      );
  EncounterTableData copyWithCompanion(EncounterTableCompanion data) {
    return EncounterTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      round: data.round.present ? data.round.value : this.round,
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
          ..write('round: $round, ')
          ..write('combatants: $combatants, ')
          ..write('engine: $engine')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, round, combatants, engine);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EncounterTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.round == this.round &&
          other.combatants == this.combatants &&
          other.engine == this.engine);
}

class EncounterTableCompanion extends UpdateCompanion<EncounterTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> round;
  final Value<Combatant> combatants;
  final Value<int> engine;
  const EncounterTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.round = const Value.absent(),
    this.combatants = const Value.absent(),
    this.engine = const Value.absent(),
  });
  EncounterTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int round,
    required Combatant combatants,
    required int engine,
  })  : name = Value(name),
        round = Value(round),
        combatants = Value(combatants),
        engine = Value(engine);
  static Insertable<EncounterTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? round,
    Expression<String>? combatants,
    Expression<int>? engine,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (round != null) 'round': round,
      if (combatants != null) 'combatants': combatants,
      if (engine != null) 'engine': engine,
    });
  }

  EncounterTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? round,
      Value<Combatant>? combatants,
      Value<int>? engine}) {
    return EncounterTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      round: round ?? this.round,
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
    if (round.present) {
      map['round'] = Variable<int>(round.value);
    }
    if (combatants.present) {
      map['combatants'] = Variable<String>(
          $EncounterTableTable.$convertercombatants.toSql(combatants.value));
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
          ..write('round: $round, ')
          ..write('combatants: $combatants, ')
          ..write('engine: $engine')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EncounterTableTable encounterTable = $EncounterTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [encounterTable];
}

typedef $$EncounterTableTableCreateCompanionBuilder = EncounterTableCompanion
    Function({
  Value<int> id,
  required String name,
  required int round,
  required Combatant combatants,
  required int engine,
});
typedef $$EncounterTableTableUpdateCompanionBuilder = EncounterTableCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<int> round,
  Value<Combatant> combatants,
  Value<int> engine,
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

  ColumnFilters<int> get round => $composableBuilder(
      column: $table.round, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Combatant, Combatant, String> get combatants =>
      $composableBuilder(
          column: $table.combatants,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get engine => $composableBuilder(
      column: $table.engine, builder: (column) => ColumnFilters(column));
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

  ColumnOrderings<int> get round => $composableBuilder(
      column: $table.round, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get combatants => $composableBuilder(
      column: $table.combatants, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get engine => $composableBuilder(
      column: $table.engine, builder: (column) => ColumnOrderings(column));
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

  GeneratedColumn<int> get round =>
      $composableBuilder(column: $table.round, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Combatant, String> get combatants =>
      $composableBuilder(
          column: $table.combatants, builder: (column) => column);

  GeneratedColumn<int> get engine =>
      $composableBuilder(column: $table.engine, builder: (column) => column);
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
            Value<int> round = const Value.absent(),
            Value<Combatant> combatants = const Value.absent(),
            Value<int> engine = const Value.absent(),
          }) =>
              EncounterTableCompanion(
            id: id,
            name: name,
            round: round,
            combatants: combatants,
            engine: engine,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required int round,
            required Combatant combatants,
            required int engine,
          }) =>
              EncounterTableCompanion.insert(
            id: id,
            name: name,
            round: round,
            combatants: combatants,
            engine: engine,
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EncounterTableTableTableManager get encounterTable =>
      $$EncounterTableTableTableManager(_db, _db.encounterTable);
}
