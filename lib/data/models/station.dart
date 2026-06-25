enum StopType {
  train(1),
  metro(2),
  lightRail(4),
  bus(5),
  coach(7),
  ferry(9),
  schoolBus(11);

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
    StopType.coach     => 'Coach',
    StopType.ferry     => 'Ferry',
    StopType.schoolBus => 'School Bus',
  };
}

class Station {
  final String   stopId;    // TEXT — may be "222010" or "G2077181"
  final String   stopName;
  final double   stopLat;
  final double   stopLon;
  final StopType type;

  const Station({
    required this.stopId,
    required this.stopName,
    required this.stopLat,
    required this.stopLon,
    required this.type,
  });

  factory Station.fromRow(Map<String, Object?> row) => Station(
    stopId: row['stop_id']   as String,
    stopName: row['stop_name'] as String,
    stopLat: row['stop_lat']  as double,
    stopLon: row['stop_lon']  as double,
    type: StopType.fromInt(row['type'] as int),
  );
}
