import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tripview_2/data/databases/station_db.dart';

class GtfsVersion {
  final int version;
  final String lastModified;
  GtfsVersion({required this.version, required this.lastModified});
  factory GtfsVersion.fromJson(Map<String, dynamic> j) => GtfsVersion(
    version: j['version'] as int,
    lastModified: j['last_modified'] as String,
  );
  Map<String, dynamic> toJson() => {'version': version, 'last_modified': lastModified};
}

class Server {
  Server._();
  static final Server instance = Server._();

  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(minutes: 5),
  ));

  final apiUrl = 'http://192.168.0.71:8000/version';
  final dbUrl = 'http://192.168.0.71:8000/gtfs.db.gz';

  GtfsVersion? _remoteCache;

  Future<bool> needUpdate() async {
    final dir = await getApplicationSupportDirectory();
    final dbPath = join(dir.path, 'gtfs.db');
    final versionPath = join(dir.path, 'gtfs_version.json');

    final res = await _dio.get(apiUrl);
    final remote = GtfsVersion.fromJson(res.data as Map<String, dynamic>);
    _remoteCache = remote;

    GtfsVersion? installed;
    final versionFile = File(versionPath);
    if (await versionFile.exists()) {
      try {
        installed = GtfsVersion.fromJson(jsonDecode(await versionFile.readAsString()));
      } catch (_) {
        installed = null;
      }
    }

    return installed == null ||
        installed.version != remote.version ||
        installed.lastModified != remote.lastModified ||
        !await File(dbPath).exists();
  }

  Future<void> update({void Function(double progress)? onProgress}) async {
    final remote = _remoteCache ??
        GtfsVersion.fromJson((await _dio.get(apiUrl)).data as Map<String, dynamic>);

    final dir = await getApplicationSupportDirectory();
    final dbPath = join(dir.path, 'gtfs.db');
    final versionPath = join(dir.path, 'gtfs_version.json');
    final tmpGzPath = join(dir.path, 'gtfs.db.gz.tmp');
    final tmpDbPath = join(dir.path, 'gtfs.db.tmp');

    await _dio.download(
      dbUrl,
      tmpGzPath,
      onReceiveProgress: (received, total) {
        if (total > 0) onProgress?.call((received / total) * 0.8);
      },
    );

    final input = File(tmpGzPath).openRead();
    final output = File(tmpDbPath).openWrite();
    await input.transform(gzip.decoder).pipe(output);
    onProgress?.call(0.9);

    await File(tmpDbPath).rename(dbPath);
    await File(versionPath).writeAsString(jsonEncode(remote.toJson()), flush: true);
    await File(tmpGzPath).delete();

    await StationDB.init();
    onProgress?.call(1.0);
  }
}