import 'package:hive_flutter/hive_flutter.dart';

part 'station.g.dart';

enum StopType {
  train(1),
  metro(401),
  lightRail(900),
  bus(714),
  ferry(4),
  regionalTrains(106),
  regionalCoaches(204),
  temporaryCoaches(205);

  const StopType(this.value);
  final int value;

  static StopType fromInt(int v) =>
    StopType.values.cast<StopType>().firstWhere(
      (e) => e.value == v,
      orElse: () => StopType.train,
    );

  String get label => switch (this) {
    StopType.train     => 'Train',
    StopType.metro     => 'Metro',
    StopType.lightRail => 'Light Rail',
    StopType.bus       => 'Bus',
    StopType.ferry     => 'Ferry',
    StopType.regionalTrains => 'Regional Trains',
    StopType.temporaryCoaches => 'Temporary Coaches',
    StopType.regionalCoaches => 'Regional Coaches',
  };

  int get bitOp => switch (this) {
    StopType.train => 1,
    StopType.metro => 32,
    StopType.lightRail => 512,
    StopType.bus => 256,
    StopType.ferry => 2,
    StopType.regionalTrains => 4,
    StopType.temporaryCoaches => 8,
    StopType.regionalCoaches => 16,
  };
}

@HiveType(typeId: 1)
class Station extends HiveObject{
  @HiveField(0) late String stopId;    // TEXT — may be "222010" or "G2077181"
  @HiveField(1) late String stopName;
  @HiveField(2) late double stopLat;
  @HiveField(3) late double stopLon;

  Station({
    required this.stopId,
    required this.stopName,
    required this.stopLat,
    required this.stopLon,
  });

  factory Station.fromRow(Map<String, Object?> row) => Station(
    stopId: row['stop_id']   as String,
    stopName: row['stop_name'] as String,
    stopLat: row['stop_lat']  as double,
    stopLon: row['stop_lon']  as double,
  );

}
