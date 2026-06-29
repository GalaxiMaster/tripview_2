// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// ignore_for_file: type=lint
class $SavedTripsTableTable extends SavedTripsTable
    with TableInfo<$SavedTripsTableTable, SavedTripsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedTripsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _fromIdMeta = const VerificationMeta('fromId');
  @override
  late final GeneratedColumn<String> fromId = GeneratedColumn<String>(
    'from_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromNameMeta = const VerificationMeta(
    'fromName',
  );
  @override
  late final GeneratedColumn<String> fromName = GeneratedColumn<String>(
    'from_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromLatMeta = const VerificationMeta(
    'fromLat',
  );
  @override
  late final GeneratedColumn<double> fromLat = GeneratedColumn<double>(
    'from_lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromLonMeta = const VerificationMeta(
    'fromLon',
  );
  @override
  late final GeneratedColumn<double> fromLon = GeneratedColumn<double>(
    'from_lon',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toIdMeta = const VerificationMeta('toId');
  @override
  late final GeneratedColumn<String> toId = GeneratedColumn<String>(
    'to_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toNameMeta = const VerificationMeta('toName');
  @override
  late final GeneratedColumn<String> toName = GeneratedColumn<String>(
    'to_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toLatMeta = const VerificationMeta('toLat');
  @override
  late final GeneratedColumn<double> toLat = GeneratedColumn<double>(
    'to_lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toLonMeta = const VerificationMeta('toLon');
  @override
  late final GeneratedColumn<double> toLon = GeneratedColumn<double>(
    'to_lon',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fromId,
    fromName,
    fromLat,
    fromLon,
    toId,
    toName,
    toLat,
    toLon,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_trips';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavedTripsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('from_id')) {
      context.handle(
        _fromIdMeta,
        fromId.isAcceptableOrUnknown(data['from_id']!, _fromIdMeta),
      );
    } else if (isInserting) {
      context.missing(_fromIdMeta);
    }
    if (data.containsKey('from_name')) {
      context.handle(
        _fromNameMeta,
        fromName.isAcceptableOrUnknown(data['from_name']!, _fromNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fromNameMeta);
    }
    if (data.containsKey('from_lat')) {
      context.handle(
        _fromLatMeta,
        fromLat.isAcceptableOrUnknown(data['from_lat']!, _fromLatMeta),
      );
    } else if (isInserting) {
      context.missing(_fromLatMeta);
    }
    if (data.containsKey('from_lon')) {
      context.handle(
        _fromLonMeta,
        fromLon.isAcceptableOrUnknown(data['from_lon']!, _fromLonMeta),
      );
    } else if (isInserting) {
      context.missing(_fromLonMeta);
    }
    if (data.containsKey('to_id')) {
      context.handle(
        _toIdMeta,
        toId.isAcceptableOrUnknown(data['to_id']!, _toIdMeta),
      );
    } else if (isInserting) {
      context.missing(_toIdMeta);
    }
    if (data.containsKey('to_name')) {
      context.handle(
        _toNameMeta,
        toName.isAcceptableOrUnknown(data['to_name']!, _toNameMeta),
      );
    } else if (isInserting) {
      context.missing(_toNameMeta);
    }
    if (data.containsKey('to_lat')) {
      context.handle(
        _toLatMeta,
        toLat.isAcceptableOrUnknown(data['to_lat']!, _toLatMeta),
      );
    } else if (isInserting) {
      context.missing(_toLatMeta);
    }
    if (data.containsKey('to_lon')) {
      context.handle(
        _toLonMeta,
        toLon.isAcceptableOrUnknown(data['to_lon']!, _toLonMeta),
      );
    } else if (isInserting) {
      context.missing(_toLonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavedTripsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedTripsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      fromId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_id'],
      )!,
      fromName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_name'],
      )!,
      fromLat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}from_lat'],
      )!,
      fromLon: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}from_lon'],
      )!,
      toId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_id'],
      )!,
      toName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_name'],
      )!,
      toLat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}to_lat'],
      )!,
      toLon: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}to_lon'],
      )!,
    );
  }

  @override
  $SavedTripsTableTable createAlias(String alias) {
    return $SavedTripsTableTable(attachedDatabase, alias);
  }
}

class SavedTripsTableData extends DataClass
    implements Insertable<SavedTripsTableData> {
  final int id;
  final String fromId;
  final String fromName;
  final double fromLat;
  final double fromLon;
  final String toId;
  final String toName;
  final double toLat;
  final double toLon;
  const SavedTripsTableData({
    required this.id,
    required this.fromId,
    required this.fromName,
    required this.fromLat,
    required this.fromLon,
    required this.toId,
    required this.toName,
    required this.toLat,
    required this.toLon,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['from_id'] = Variable<String>(fromId);
    map['from_name'] = Variable<String>(fromName);
    map['from_lat'] = Variable<double>(fromLat);
    map['from_lon'] = Variable<double>(fromLon);
    map['to_id'] = Variable<String>(toId);
    map['to_name'] = Variable<String>(toName);
    map['to_lat'] = Variable<double>(toLat);
    map['to_lon'] = Variable<double>(toLon);
    return map;
  }

  SavedTripsTableCompanion toCompanion(bool nullToAbsent) {
    return SavedTripsTableCompanion(
      id: Value(id),
      fromId: Value(fromId),
      fromName: Value(fromName),
      fromLat: Value(fromLat),
      fromLon: Value(fromLon),
      toId: Value(toId),
      toName: Value(toName),
      toLat: Value(toLat),
      toLon: Value(toLon),
    );
  }

  factory SavedTripsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedTripsTableData(
      id: serializer.fromJson<int>(json['id']),
      fromId: serializer.fromJson<String>(json['fromId']),
      fromName: serializer.fromJson<String>(json['fromName']),
      fromLat: serializer.fromJson<double>(json['fromLat']),
      fromLon: serializer.fromJson<double>(json['fromLon']),
      toId: serializer.fromJson<String>(json['toId']),
      toName: serializer.fromJson<String>(json['toName']),
      toLat: serializer.fromJson<double>(json['toLat']),
      toLon: serializer.fromJson<double>(json['toLon']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fromId': serializer.toJson<String>(fromId),
      'fromName': serializer.toJson<String>(fromName),
      'fromLat': serializer.toJson<double>(fromLat),
      'fromLon': serializer.toJson<double>(fromLon),
      'toId': serializer.toJson<String>(toId),
      'toName': serializer.toJson<String>(toName),
      'toLat': serializer.toJson<double>(toLat),
      'toLon': serializer.toJson<double>(toLon),
    };
  }

  SavedTripsTableData copyWith({
    int? id,
    String? fromId,
    String? fromName,
    double? fromLat,
    double? fromLon,
    String? toId,
    String? toName,
    double? toLat,
    double? toLon,
  }) => SavedTripsTableData(
    id: id ?? this.id,
    fromId: fromId ?? this.fromId,
    fromName: fromName ?? this.fromName,
    fromLat: fromLat ?? this.fromLat,
    fromLon: fromLon ?? this.fromLon,
    toId: toId ?? this.toId,
    toName: toName ?? this.toName,
    toLat: toLat ?? this.toLat,
    toLon: toLon ?? this.toLon,
  );
  SavedTripsTableData copyWithCompanion(SavedTripsTableCompanion data) {
    return SavedTripsTableData(
      id: data.id.present ? data.id.value : this.id,
      fromId: data.fromId.present ? data.fromId.value : this.fromId,
      fromName: data.fromName.present ? data.fromName.value : this.fromName,
      fromLat: data.fromLat.present ? data.fromLat.value : this.fromLat,
      fromLon: data.fromLon.present ? data.fromLon.value : this.fromLon,
      toId: data.toId.present ? data.toId.value : this.toId,
      toName: data.toName.present ? data.toName.value : this.toName,
      toLat: data.toLat.present ? data.toLat.value : this.toLat,
      toLon: data.toLon.present ? data.toLon.value : this.toLon,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedTripsTableData(')
          ..write('id: $id, ')
          ..write('fromId: $fromId, ')
          ..write('fromName: $fromName, ')
          ..write('fromLat: $fromLat, ')
          ..write('fromLon: $fromLon, ')
          ..write('toId: $toId, ')
          ..write('toName: $toName, ')
          ..write('toLat: $toLat, ')
          ..write('toLon: $toLon')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fromId,
    fromName,
    fromLat,
    fromLon,
    toId,
    toName,
    toLat,
    toLon,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedTripsTableData &&
          other.id == this.id &&
          other.fromId == this.fromId &&
          other.fromName == this.fromName &&
          other.fromLat == this.fromLat &&
          other.fromLon == this.fromLon &&
          other.toId == this.toId &&
          other.toName == this.toName &&
          other.toLat == this.toLat &&
          other.toLon == this.toLon);
}

class SavedTripsTableCompanion extends UpdateCompanion<SavedTripsTableData> {
  final Value<int> id;
  final Value<String> fromId;
  final Value<String> fromName;
  final Value<double> fromLat;
  final Value<double> fromLon;
  final Value<String> toId;
  final Value<String> toName;
  final Value<double> toLat;
  final Value<double> toLon;
  const SavedTripsTableCompanion({
    this.id = const Value.absent(),
    this.fromId = const Value.absent(),
    this.fromName = const Value.absent(),
    this.fromLat = const Value.absent(),
    this.fromLon = const Value.absent(),
    this.toId = const Value.absent(),
    this.toName = const Value.absent(),
    this.toLat = const Value.absent(),
    this.toLon = const Value.absent(),
  });
  SavedTripsTableCompanion.insert({
    this.id = const Value.absent(),
    required String fromId,
    required String fromName,
    required double fromLat,
    required double fromLon,
    required String toId,
    required String toName,
    required double toLat,
    required double toLon,
  }) : fromId = Value(fromId),
       fromName = Value(fromName),
       fromLat = Value(fromLat),
       fromLon = Value(fromLon),
       toId = Value(toId),
       toName = Value(toName),
       toLat = Value(toLat),
       toLon = Value(toLon);
  static Insertable<SavedTripsTableData> custom({
    Expression<int>? id,
    Expression<String>? fromId,
    Expression<String>? fromName,
    Expression<double>? fromLat,
    Expression<double>? fromLon,
    Expression<String>? toId,
    Expression<String>? toName,
    Expression<double>? toLat,
    Expression<double>? toLon,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fromId != null) 'from_id': fromId,
      if (fromName != null) 'from_name': fromName,
      if (fromLat != null) 'from_lat': fromLat,
      if (fromLon != null) 'from_lon': fromLon,
      if (toId != null) 'to_id': toId,
      if (toName != null) 'to_name': toName,
      if (toLat != null) 'to_lat': toLat,
      if (toLon != null) 'to_lon': toLon,
    });
  }

  SavedTripsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? fromId,
    Value<String>? fromName,
    Value<double>? fromLat,
    Value<double>? fromLon,
    Value<String>? toId,
    Value<String>? toName,
    Value<double>? toLat,
    Value<double>? toLon,
  }) {
    return SavedTripsTableCompanion(
      id: id ?? this.id,
      fromId: fromId ?? this.fromId,
      fromName: fromName ?? this.fromName,
      fromLat: fromLat ?? this.fromLat,
      fromLon: fromLon ?? this.fromLon,
      toId: toId ?? this.toId,
      toName: toName ?? this.toName,
      toLat: toLat ?? this.toLat,
      toLon: toLon ?? this.toLon,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fromId.present) {
      map['from_id'] = Variable<String>(fromId.value);
    }
    if (fromName.present) {
      map['from_name'] = Variable<String>(fromName.value);
    }
    if (fromLat.present) {
      map['from_lat'] = Variable<double>(fromLat.value);
    }
    if (fromLon.present) {
      map['from_lon'] = Variable<double>(fromLon.value);
    }
    if (toId.present) {
      map['to_id'] = Variable<String>(toId.value);
    }
    if (toName.present) {
      map['to_name'] = Variable<String>(toName.value);
    }
    if (toLat.present) {
      map['to_lat'] = Variable<double>(toLat.value);
    }
    if (toLon.present) {
      map['to_lon'] = Variable<double>(toLon.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedTripsTableCompanion(')
          ..write('id: $id, ')
          ..write('fromId: $fromId, ')
          ..write('fromName: $fromName, ')
          ..write('fromLat: $fromLat, ')
          ..write('fromLon: $fromLon, ')
          ..write('toId: $toId, ')
          ..write('toName: $toName, ')
          ..write('toLat: $toLat, ')
          ..write('toLon: $toLon')
          ..write(')'))
        .toString();
  }
}

abstract class _$UserDB extends GeneratedDatabase {
  _$UserDB(QueryExecutor e) : super(e);
  $UserDBManager get managers => $UserDBManager(this);
  late final $SavedTripsTableTable savedTripsTable = $SavedTripsTableTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [savedTripsTable];
}

typedef $$SavedTripsTableTableCreateCompanionBuilder =
    SavedTripsTableCompanion Function({
      Value<int> id,
      required String fromId,
      required String fromName,
      required double fromLat,
      required double fromLon,
      required String toId,
      required String toName,
      required double toLat,
      required double toLon,
    });
typedef $$SavedTripsTableTableUpdateCompanionBuilder =
    SavedTripsTableCompanion Function({
      Value<int> id,
      Value<String> fromId,
      Value<String> fromName,
      Value<double> fromLat,
      Value<double> fromLon,
      Value<String> toId,
      Value<String> toName,
      Value<double> toLat,
      Value<double> toLon,
    });

class $$SavedTripsTableTableFilterComposer
    extends Composer<_$UserDB, $SavedTripsTableTable> {
  $$SavedTripsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromId => $composableBuilder(
    column: $table.fromId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromName => $composableBuilder(
    column: $table.fromName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fromLat => $composableBuilder(
    column: $table.fromLat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fromLon => $composableBuilder(
    column: $table.fromLon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toId => $composableBuilder(
    column: $table.toId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toName => $composableBuilder(
    column: $table.toName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get toLat => $composableBuilder(
    column: $table.toLat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get toLon => $composableBuilder(
    column: $table.toLon,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavedTripsTableTableOrderingComposer
    extends Composer<_$UserDB, $SavedTripsTableTable> {
  $$SavedTripsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromId => $composableBuilder(
    column: $table.fromId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromName => $composableBuilder(
    column: $table.fromName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fromLat => $composableBuilder(
    column: $table.fromLat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fromLon => $composableBuilder(
    column: $table.fromLon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toId => $composableBuilder(
    column: $table.toId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toName => $composableBuilder(
    column: $table.toName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get toLat => $composableBuilder(
    column: $table.toLat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get toLon => $composableBuilder(
    column: $table.toLon,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavedTripsTableTableAnnotationComposer
    extends Composer<_$UserDB, $SavedTripsTableTable> {
  $$SavedTripsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fromId =>
      $composableBuilder(column: $table.fromId, builder: (column) => column);

  GeneratedColumn<String> get fromName =>
      $composableBuilder(column: $table.fromName, builder: (column) => column);

  GeneratedColumn<double> get fromLat =>
      $composableBuilder(column: $table.fromLat, builder: (column) => column);

  GeneratedColumn<double> get fromLon =>
      $composableBuilder(column: $table.fromLon, builder: (column) => column);

  GeneratedColumn<String> get toId =>
      $composableBuilder(column: $table.toId, builder: (column) => column);

  GeneratedColumn<String> get toName =>
      $composableBuilder(column: $table.toName, builder: (column) => column);

  GeneratedColumn<double> get toLat =>
      $composableBuilder(column: $table.toLat, builder: (column) => column);

  GeneratedColumn<double> get toLon =>
      $composableBuilder(column: $table.toLon, builder: (column) => column);
}

class $$SavedTripsTableTableTableManager
    extends
        RootTableManager<
          _$UserDB,
          $SavedTripsTableTable,
          SavedTripsTableData,
          $$SavedTripsTableTableFilterComposer,
          $$SavedTripsTableTableOrderingComposer,
          $$SavedTripsTableTableAnnotationComposer,
          $$SavedTripsTableTableCreateCompanionBuilder,
          $$SavedTripsTableTableUpdateCompanionBuilder,
          (
            SavedTripsTableData,
            BaseReferences<
              _$UserDB,
              $SavedTripsTableTable,
              SavedTripsTableData
            >,
          ),
          SavedTripsTableData,
          PrefetchHooks Function()
        > {
  $$SavedTripsTableTableTableManager(_$UserDB db, $SavedTripsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedTripsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedTripsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedTripsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> fromId = const Value.absent(),
                Value<String> fromName = const Value.absent(),
                Value<double> fromLat = const Value.absent(),
                Value<double> fromLon = const Value.absent(),
                Value<String> toId = const Value.absent(),
                Value<String> toName = const Value.absent(),
                Value<double> toLat = const Value.absent(),
                Value<double> toLon = const Value.absent(),
              }) => SavedTripsTableCompanion(
                id: id,
                fromId: fromId,
                fromName: fromName,
                fromLat: fromLat,
                fromLon: fromLon,
                toId: toId,
                toName: toName,
                toLat: toLat,
                toLon: toLon,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String fromId,
                required String fromName,
                required double fromLat,
                required double fromLon,
                required String toId,
                required String toName,
                required double toLat,
                required double toLon,
              }) => SavedTripsTableCompanion.insert(
                id: id,
                fromId: fromId,
                fromName: fromName,
                fromLat: fromLat,
                fromLon: fromLon,
                toId: toId,
                toName: toName,
                toLat: toLat,
                toLon: toLon,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavedTripsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$UserDB,
      $SavedTripsTableTable,
      SavedTripsTableData,
      $$SavedTripsTableTableFilterComposer,
      $$SavedTripsTableTableOrderingComposer,
      $$SavedTripsTableTableAnnotationComposer,
      $$SavedTripsTableTableCreateCompanionBuilder,
      $$SavedTripsTableTableUpdateCompanionBuilder,
      (
        SavedTripsTableData,
        BaseReferences<_$UserDB, $SavedTripsTableTable, SavedTripsTableData>,
      ),
      SavedTripsTableData,
      PrefetchHooks Function()
    >;

class $UserDBManager {
  final _$UserDB _db;
  $UserDBManager(this._db);
  $$SavedTripsTableTableTableManager get savedTripsTable =>
      $$SavedTripsTableTableTableManager(_db, _db.savedTripsTable);
}
