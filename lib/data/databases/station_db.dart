import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tripview_2/data/models/station.dart';
import 'package:tripview_2/data/models/stop.dart';
import 'package:tripview_2/data/models/trip.dart';
import 'package:tripview_2/tools.dart';

part 'station_db.g.dart';

@DriftDatabase()
class StationDB extends _$StationDB {
  StationDB._(super.e);

  static StationDB? _instance;
  static StationDB get instance => _instance!;

  @override
  int get schemaVersion => 1;

  static Future<void> init() async {
    if (_instance != null) return;
    final dir = await getApplicationSupportDirectory();
    final dbPath = join(dir.path, 'gtfs.db');

    if (true) { // !await File(dbPath).exists()
      final bytes = await decompressGZip('gtfs.db');
      await File(dbPath).writeAsBytes(bytes, flush: true);
    }

    _instance = StationDB._(
      NativeDatabase.createInBackground(
        File(dbPath),
        setup: (db) {
          db.execute('PRAGMA journal_mode=WAL');
        },
      ),
    );
  }

  Future<List<Station>> getStops({StopType? type, int limit = 200}) async {
    final typeClause = type != null
        ? 'WHERE transport_modes & ${type.bitOp} != 0 AND location_type = 1'
        : '';
    final rows = await customSelect(
      'SELECT * FROM stops $typeClause ORDER BY stop_name LIMIT $limit',
    ).get();
    return rows.map((r) => Station.fromRow(r.data)).toList();
  }

  Future<List<Station>> searchStops({
    required String query,
    StopType? type,
    int limit = 100,
  }) async {
    if (query.trim().isEmpty) return getStops(type: type, limit: limit);

    final typeClause = type != null
        ? 'AND transport_modes & ${type.bitOp} != 0 AND location_type = 1'
        : '';

    final rows = await customSelect('''
      SELECT * FROM stops
      WHERE rowid IN (
        SELECT rowid FROM stops_fts WHERE stops_fts MATCH ?
      )
      $typeClause
      ORDER BY stop_name
      LIMIT $limit
    ''', variables: [Variable('${query.trim()}*')]).get();

    return rows.map((r) => Station.fromRow(r.data)).toList();
  }

  Future<List<Trip>> getTripsBetween(
    String parentStationA,
    String parentStationB,
  ) async {
    final now = DateTime.now();
    final today = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final dayColumn = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'][now.weekday - 1];

    final rows = await customSelect('''
      SELECT t.*, depart.depart_time, arrive.arrive_time
      FROM trips t
      JOIN (
        SELECT service_id FROM calendar
        WHERE $dayColumn = 1
          AND start_date <= ?
          AND end_date   >= ?
        UNION
        SELECT service_id FROM calendar_dates
        WHERE date = ? AND exception_type = 1
      ) svc ON svc.service_id = t.service_id
      JOIN (
        SELECT trip_id, MIN(departure_time) AS depart_time
        FROM stop_times
        WHERE stop_id IN (SELECT stop_id FROM stops WHERE parent_station = ?)
        GROUP BY trip_id
      ) depart ON depart.trip_id = t.trip_id
      JOIN (
        SELECT trip_id, MIN(arrival_time) AS arrive_time
        FROM stop_times
        WHERE stop_id IN (SELECT stop_id FROM stops WHERE parent_station = ?)
        GROUP BY trip_id
      ) arrive ON arrive.trip_id = t.trip_id
      WHERE depart.depart_time < arrive.arrive_time
        AND t.service_id NOT IN (
          SELECT service_id FROM calendar_dates
          WHERE date = ? AND exception_type = 2
        )
      ORDER BY depart.depart_time
    ''', variables: [
      Variable(today), Variable(today), Variable(today),
      Variable(parentStationA), Variable(parentStationB),
      Variable(today),
    ]).get();

    return rows.map((r) => Trip.fromRow(r.data)).toList();
  }

  Future<List<Stop>> getTripStops(String tripId) async {
    final rows = await customSelect('''
      SELECT
        st.stop_sequence,
        st.arrival_time,
        st.departure_time,
        st.stop_id,
        s.stop_name,
        s.stop_lat,
        s.stop_lon,
        s.parent_station
      FROM stop_times st
      JOIN stops s ON s.stop_id = st.stop_id
      WHERE st.trip_id = ?
      ORDER BY st.stop_sequence
    ''', variables: [Variable(tripId)]).get();

    return rows.map((r) => Stop.fromRow(r.data)).toList();
  }

  Future<void> close() async {
    await _instance?.close();
    _instance = null;
  }
}