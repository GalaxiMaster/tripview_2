
class Stop {
  final int stopSequence;
  final String arrivalTime;
  final String departureTime;
  final String stopId;
  final String stopName;
  final double stopLat;
  final double stopLon;
  final String? parentStation;

  Stop({
    required this.stopSequence, 
    required this.arrivalTime, 
    required this.departureTime, 
    required this.stopId, 
    required this.stopName, 
    required this.stopLat, 
    required this.stopLon, 
    this.parentStation
  });
  
  factory Stop.fromRow(Map<String, Object?> row) => Stop(
    stopId: row['stop_id']   as String,
    stopName: row['stop_name'] as String,
    stopLat: row['stop_lat']  as double,
    stopLon: row['stop_lon']  as double,
    stopSequence: row['stop_sequence'] as int,
    arrivalTime: row['arrival_time'] as String,
    departureTime: row['departure_time'] as String,
    parentStation: row['parent_station'] as String?
  );
}