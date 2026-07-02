import 'dart:io';
import 'package:flutter/services.dart';

Future<List<int>> decompressGZip(String dbName) async{
  final ByteData assetData = await rootBundle.load('assets/$dbName.gz');
  final List<int> compressedBytes = assetData.buffer.asUint8List();

  final List<int> decompressedBytes = gzip.decode(compressedBytes);
  return decompressedBytes;
}

String formatGtfsSecs(int secs) {
  final h = (secs ~/ 3600) % 24; // wrap 25:xx -> 01:xx for display
  final m = (secs % 3600) ~/ 60;
  return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
}