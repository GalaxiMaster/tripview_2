import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tripview_2/data/models/journey.dart';
import 'package:tripview_2/data/models/station.dart';
import 'package:tripview_2/data/models/stop.dart';
import 'package:tripview_2/data/models/trip.dart';
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
    String parentA,
    String parentB,
    Set<String> activeServiceIds,
  ) async {
    if (activeServiceIds.isEmpty) return [];
    final placeholders = activeServiceIds.map((_) => '?').join(',');

    final rows = await customSelect('''
      SELECT t.*,
            depart.departure_secs,
            arrive.arrival_secs
      FROM trips t
      JOIN (
        SELECT trip_id, MIN(departure_secs) AS departure_secs
        FROM stop_times
        WHERE parent_station = ?
        GROUP BY trip_id
      ) depart ON depart.trip_id = t.trip_id
      JOIN (
        SELECT trip_id, MIN(arrival_secs) AS arrival_secs
        FROM stop_times
        WHERE parent_station = ?
        GROUP BY trip_id
      ) arrive ON arrive.trip_id = t.trip_id
      WHERE depart.departure_secs < arrive.arrival_secs
        AND t.service_id IN ($placeholders)
      ORDER BY depart.departure_secs
    ''', variables: [
      Variable(parentA),
      Variable(parentB),
      ...activeServiceIds.map(Variable.new),
    ]).get();

    return rows.map((r) => Trip.fromRow(r.data)).toList();
  }
  Future<Map<String, List<Trip>>> getTripsFromStationToAny(
    String origin,
    Set<String> destinations,
    Set<String> activeServiceIds,
  ) async {
    if (destinations.isEmpty || activeServiceIds.isEmpty) return {};
    final destPh = destinations.map((_) => '?').join(',');
    final svcPh = activeServiceIds.map((_) => '?').join(',');

    final rows = await customSelect('''
      SELECT t.*, depart.departure_secs, arrive.arrival_secs,
            arrive.parent_station AS dest_station
      FROM trips t
      JOIN (
        SELECT trip_id, MIN(departure_secs) AS departure_secs
        FROM stop_times WHERE parent_station = ?
        GROUP BY trip_id
      ) depart ON depart.trip_id = t.trip_id
      JOIN (
        SELECT trip_id, parent_station, MIN(arrival_secs) AS arrival_secs
        FROM stop_times WHERE parent_station IN ($destPh)
        GROUP BY trip_id, parent_station
      ) arrive ON arrive.trip_id = t.trip_id
      WHERE depart.departure_secs < arrive.arrival_secs
        AND t.service_id IN ($svcPh)
      ORDER BY depart.departure_secs
    ''', variables: [
      Variable(origin),
      ...destinations.map(Variable.new),
      ...activeServiceIds.map(Variable.new),
    ]).get();

    final result = <String, List<Trip>>{};
    for (final r in rows) {
      result.putIfAbsent(r.data['dest_station'] as String, () => [])
          .add(Trip.fromRow(r.data));
    }
    return result;
  }

  Future<Map<String, List<Trip>>> getTripsFromAnyToStation(
    Set<String> origins,
    String destination,
    Set<String> activeServiceIds,
  ) async {
    if (origins.isEmpty || activeServiceIds.isEmpty) return {};
    final origPh = origins.map((_) => '?').join(',');
    final svcPh = activeServiceIds.map((_) => '?').join(',');

    final rows = await customSelect('''
      SELECT t.*, depart.departure_secs, depart.parent_station AS orig_station,
            arrive.arrival_secs
      FROM trips t
      JOIN (
        SELECT trip_id, parent_station, MIN(departure_secs) AS departure_secs
        FROM stop_times WHERE parent_station IN ($origPh)
        GROUP BY trip_id, parent_station
      ) depart ON depart.trip_id = t.trip_id
      JOIN (
        SELECT trip_id, MIN(arrival_secs) AS arrival_secs
        FROM stop_times WHERE parent_station = ?
        GROUP BY trip_id
      ) arrive ON arrive.trip_id = t.trip_id
      WHERE depart.departure_secs < arrive.arrival_secs
        AND t.service_id IN ($svcPh)
      ORDER BY depart.departure_secs
    ''', variables: [
      ...origins.map(Variable.new),
      Variable(destination),
      ...activeServiceIds.map(Variable.new),
    ]).get();

    final result = <String, List<Trip>>{};
    for (final r in rows) {
      result.putIfAbsent(r.data['orig_station'] as String, () => [])
          .add(Trip.fromRow(r.data));
    }
    return result;
  }
  Future<Set<String>> getActiveServiceIds() async {
    final now = DateTime.now();
    final today = '${now.year}${now.month.toString().padLeft(2,'0')}${now.day.toString().padLeft(2,'0')}';
    final dayCol = ['monday','tuesday','wednesday','thursday',
                    'friday','saturday','sunday'][now.weekday - 1];

    final rows = await customSelect('''
      SELECT service_id FROM calendar
      WHERE $dayCol = 1 AND start_date <= ? AND end_date >= ?
      UNION
      SELECT service_id FROM calendar_dates
      WHERE date = ? AND exception_type = 1
      EXCEPT
      SELECT service_id FROM calendar_dates
      WHERE date = ? AND exception_type = 2
    ''', variables: [
      Variable(today), Variable(today),
      Variable(today), Variable(today),
    ]).get();

    return rows.map((r) => r.data['service_id'] as String).toSet();
  }

  Future<List<Journey>> getJourneysBetween(
    String parentA,
    String parentB,
  ) async {
    final activeIds = await getActiveServiceIds();

    final direct = await getTripsBetween(parentA, parentB, activeIds);
    if (direct.isNotEmpty) {
      return direct.map((t) => Journey(legs: [t], interchangeNames: [])).toList();
    }

    final neighbours = await customSelect('''
      SELECT a1.to_station
      FROM station_adjacency a1
      JOIN station_adjacency a2
        ON a2.from_station = a1.to_station
        AND a2.to_station = ?
      WHERE a1.from_station = ?
    ''', variables: [Variable(parentB), Variable(parentA)]).get();

    final mids = neighbours
        .map((r) => r.data['to_station'] as String)
        .where((m) => m != parentA && m != parentB)
        .toSet();

    if (mids.isEmpty) return [];

    final results = await Future.wait([
      getTripsFromStationToAny(parentA, mids, activeIds),
      getTripsFromAnyToStation(mids, parentB, activeIds),
    ]);
    final leg1Map = results[0];
    final leg2Map = results[1];

    final candidates = <String, Journey>{};

    for (final mid in mids) {
      final leg1List = leg1Map[mid];
      final leg2List = leg2Map[mid];
      if (leg1List == null || leg2List == null) continue;

      for (final leg1 in leg1List) {
        final bestLeg2 = leg2List
            .where((t) => _canConnect(leg1.arriveTime, t.departTime, minMins: 3))
            .fold<Trip?>(null, (best, t) {
              if (best == null) return t;
              return t.arriveTime < best.arriveTime ? t : best;
            });

        if (bestLeg2 == null) continue;

        final existing = candidates[leg1.tripId];
        if (existing == null ||
            bestLeg2.arriveTime < existing.legs.last.arriveTime) {
            candidates[leg1.tripId] = Journey(
            legs: [leg1, bestLeg2],
            interchangeNames: [mid],
          );
        }
      }
    }

    return candidates.values.toList()
      ..sort((a, b) => a.departTime.compareTo(b.departTime));
  }

  bool _canConnect(int arrive, int depart, {required int minMins}) {
    return depart - arrive >= minMins * 60;
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

  @override
  Future<void> close() async {
    await _instance?.close();
    _instance = null;
  }
}