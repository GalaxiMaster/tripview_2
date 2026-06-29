// lib/data/databases/user_db.dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tripview_2/data/models/station.dart';
import 'package:tripview_2/data/models/trip.dart';

part 'user_settings.g.dart';

class SavedTripsTable extends Table {
  @override
  String get tableName => 'saved_trips';

  IntColumn get id         => integer().autoIncrement()();
  TextColumn get fromId    => text()();
  TextColumn get fromName  => text()();
  RealColumn get fromLat   => real()();
  RealColumn get fromLon   => real()();
  TextColumn get toId      => text()();
  TextColumn get toName    => text()();
  RealColumn get toLat     => real()();
  RealColumn get toLon     => real()();
}

@DriftDatabase(tables: [SavedTripsTable])
class SavedTrips extends _$UserDB {
  SavedTrips._(super.e);

  static SavedTrips? _instance;
  static SavedTrips get instance => _instance!;

  @override
  int get schemaVersion => 1;

  static Future<void> init() async {
    if (_instance != null) return;
    final dir = await getApplicationSupportDirectory();
    _instance = SavedTrips._(
      NativeDatabase.createInBackground(File(join(dir.path, 'user.db'))),
    );
  }

  // Convert to/from your existing Station/UserTrip models
  Future<List<UserTrip>> getSavedTrips() async {
    final rows = await select(savedTripsTable).get();
    return rows.map((r) => UserTrip(
      start: Station(stopId: r.fromId, stopName: r.fromName, stopLat: r.fromLat, stopLon: r.fromLon),
      end:   Station(stopId: r.toId,   stopName: r.toName,   stopLat: r.toLat,   stopLon: r.toLon),
    )).toList();
  }

  Future<void> addTrip(UserTrip trip) async {
    await into(savedTripsTable).insert(SavedTripsTableCompanion.insert(
      fromId:   trip.start!.stopId,
      fromName: trip.start!.stopName,
      fromLat:  trip.start!.stopLat,
      fromLon:  trip.start!.stopLon,
      toId:     trip.end!.stopId,
      toName:   trip.end!.stopName,
      toLat:    trip.end!.stopLat,
      toLon:    trip.end!.stopLon,
    ));
  }

  Future<void> deleteTrip(UserTrip trip) async {
    await (delete(savedTripsTable)
      ..where((t) => t.fromId.equals(trip.start!.stopId) &
                     t.toId.equals(trip.end!.stopId))
    ).go();
  }

  // Optional: reactive stream so UI updates automatically when trips change
  Stream<List<UserTrip>> watchSavedTrips() {
    return select(savedTripsTable).watch().map((rows) =>
      rows.map((r) => UserTrip(
        start: Station(stopId: r.fromId, stopName: r.fromName, stopLat: r.fromLat, stopLon: r.fromLon),
        end:   Station(stopId: r.toId,   stopName: r.toName,   stopLat: r.toLat,   stopLon: r.toLon),
      )).toList()
    );
  }
}