import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:tripview_2/data/models/station.dart';
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