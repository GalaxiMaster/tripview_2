import 'dart:io';
import 'package:flutter/services.dart';

Future<List<int>> decompressGZip(String dbName) async{
  final ByteData assetData = await rootBundle.load('assets/$dbName.gz');
  final List<int> compressedBytes = assetData.buffer.asUint8List();

  final List<int> decompressedBytes = gzip.decode(compressedBytes);
  return decompressedBytes;
}