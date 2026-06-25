import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tripview_2/data/models/station.dart';

class StationDB {
  StationDB._();
  static final StationDB instance = StationDB._();

  Database? _db;

  Future<void> open() async {
    if (_db != null) return;

    final dir    = await getApplicationSupportDirectory();
    final dbPath = join(dir.path, 'stops.db');

    if (!await File(dbPath).exists()) {
      final data  = await rootBundle.load('assets/stops.db');
      final bytes = data.buffer.asUint8List();
      await File(dbPath).writeAsBytes(bytes, flush: true);
    }

    _db = await openDatabase(dbPath, readOnly: true);
  }

  Future<Database> get _database async {
    await open();
    return _db!;
  }

  // Queries
  Future<List<Station>> getStops({StopType? type, int limit = 200}) async {
    final db = await _database;
    final typeClause = type != null ? 'WHERE type = ${type.value}' : '';
    final rows = await db.rawQuery(
      'SELECT * FROM stops $typeClause ORDER BY stop_name LIMIT $limit',
    );
    return rows.map(Station.fromRow).toList();
  }

  Future<List<Station>> searchStops({
    required String query,
    StopType? type,
    int limit = 100,
  }) async {
    if (query.trim().isEmpty) return getStops(type: type, limit: limit);

    final db = await _database;
    final typeClause = type != null ? 'AND s.type = ${type.value}' : '';

    // Join on rowid - the FTS table stores SQLite's integer rowid, not stop_id.
    final rows = await db.rawQuery('''
      SELECT s.*
      FROM   stops s
      INNER  JOIN stops_fts f ON f.rowid = s.rowid
      WHERE  stops_fts MATCH ?
      $typeClause
      ORDER  BY s.stop_name
      LIMIT  $limit
    ''', [query.trim()]);

    return rows.map(Station.fromRow).toList();
  }

  Future<Station?> getStop(String stopId) async {
    final db   = await _database;
    final rows = await db.query('stops', where: 'stop_id = ?', whereArgs: [stopId]);
    return rows.isEmpty ? null : Station.fromRow(rows.first);
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}