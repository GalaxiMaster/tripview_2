import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:tripview_2/data/models/station.dart';
import 'package:tripview_2/data/models/stop.dart';
import 'package:tripview_2/data/models/trip.dart';
import 'package:tripview_2/tools.dart';

class StationDB {
  StationDB._();
  static final StationDB instance = StationDB._();

  Database? _db;

  Future<void> open() async {
    if (_db != null) return;

    final dir = await getApplicationSupportDirectory();
    final dbPath = join(dir.path, 'stops.db');

    if (true) { // !await File(dbPath).exists()
      final bytes = await decompressGZip('stops.db');
      await File(dbPath).writeAsBytes(bytes, flush: true);
    }

    _db = sqlite3.open(dbPath, mode: OpenMode.readOnly);
    final Map dbs = {
      'st_db': 'stop_times.db',
      'trips_db': 'trips.db',
      'routes_db': 'routes.db',
      'cal_db': 'calendar.db',
      'cal_dates_db': 'calendar_dates.db',
    };
    for (final MapEntry db in dbs.entries) {  
      final dbPath = join(dir.path, db.value);

      if (true) { // !await File(dbPath).exists()
        final bytes = await decompressGZip(db.value);
        await File(dbPath).writeAsBytes(bytes, flush: true);
      }
      _db?.execute("ATTACH DATABASE '$dbPath' AS ${db.key}");
    }
  }

  Future<Database> get _database async {
    await open();
    return _db!;
  }
  // Queries
  Future<List<Station>> getStops({StopType? type, int limit = 200}) async {
    final db = await _database;
    final typeClause = type != null ? 'WHERE transport_modes & ${type.bitOp} != 0 AND location_type = 1' : '';
    final rows = db.select(
      'SELECT * FROM stops $typeClause ORDER BY stop_name LIMIT $limit',
    );
    return rows.map(Station.fromRow).toList();
  }

  Future<List<Station>> searchStops({
    required String query,
    StopType? type,
    int limit = 100,
  }) async{
    if (query.trim().isEmpty) return getStops(type: type, limit: limit);
    final db = await _database;

    final typeClause = type != null
        ? 'AND transport_modes & ${type.bitOp} != 0 AND location_type = 1'
        : '';

    final rows = db.select('''
      SELECT * FROM stops
      WHERE rowid IN (
        SELECT rowid FROM stops_fts WHERE stops_fts MATCH ?
      )
      $typeClause
      ORDER BY stop_name
      LIMIT $limit
    ''', ['${query.trim()}*']);

    return rows.map(Station.fromRow).toList();
  }
  Future<List<Trip>> getTripsBetween(String parentStationA, String parentStationB) async{
    final db = await _database;
    final now = DateTime.now();

    final today = '${now.year}${now.month.toString().padLeft(2,'0')}${now.day.toString().padLeft(2,'0')}';

    final dayColumn = ['monday','tuesday','wednesday','thursday','friday','saturday','sunday'][now.weekday - 1];

    final rows = db.select('''
      SELECT t.*, depart.depart_time, arrive.arrive_time
      FROM trips_db.trips t
      JOIN (
        SELECT service_id FROM cal_db.calendar
        WHERE $dayColumn = 1
          AND start_date <= ?
          AND end_date   >= ?
        UNION
        SELECT service_id FROM cal_dates_db.calendar_dates
        WHERE date = ? AND exception_type = 1
      ) svc ON svc.service_id = t.service_id
      JOIN (
        SELECT trip_id, MIN(departure_time) AS depart_time
        FROM st_db.stop_times
        WHERE stop_id IN (SELECT stop_id FROM stops WHERE parent_station = ?)
        GROUP BY trip_id
      ) depart ON depart.trip_id = t.trip_id
      JOIN (
        SELECT trip_id, MIN(arrival_time) AS arrive_time
        FROM st_db.stop_times
        WHERE stop_id IN (SELECT stop_id FROM stops WHERE parent_station = ?)
        GROUP BY trip_id
      ) arrive ON arrive.trip_id = t.trip_id
      WHERE depart.depart_time < arrive.arrive_time
        AND t.service_id NOT IN (
          SELECT service_id FROM cal_dates_db.calendar_dates
          WHERE date = ? AND exception_type = 2
        )
      ORDER BY depart.depart_time
    ''', [today, today, today, parentStationA, parentStationB, today]);
    return rows.map(Trip.fromRow).toList();
  }
  Future<List<Stop>> getTripStops(String tripId, {String? fromParent, String? toParent}) async {
    final db = await _database;

    final rows = db.select('''
      SELECT
        st.stop_sequence,
        st.arrival_time,
        st.departure_time,
        st.stop_id,
        s.stop_name,
        s.stop_lat,
        s.stop_lon,
        s.parent_station
      FROM st_db.stop_times st
      JOIN stops s ON s.stop_id = st.stop_id
      WHERE st.trip_id = ?
      ORDER BY st.stop_sequence
    ''', [tripId]);

    return rows.map(Stop.fromRow).toList();
  }
  // Future<Station?> getStop(String stopId) async {
  //   final db   = await _database;
  //   final rows = await db.select('stops', where: 'stop_id = ?', whereArgs: [stopId]);
  //   return rows.isEmpty ? null : Station.fromRow(rows.first);
  // }

  Future<void> close() async {
    _db?.dispose();
    _db = null;
  }
}