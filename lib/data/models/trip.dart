class UserTrip {
  final String? startId;
  final String? endId;
  UserTrip({this.startId, this.endId});
  
  UserTrip copyWith({
    String? startId,
    String? endId,
  }) {
    return UserTrip(
      startId: startId ?? this.startId, 
      endId: endId ?? this.endId
    );
  }

  ({UserTrip trip, bool isComplete}) addPart(String id) {
    if (startId == null) {
      final newTrip = UserTrip(startId: id);
      return (trip: newTrip, isComplete: false);
    } else if (endId == null) {
      final newTrip = UserTrip(startId: startId, endId: id);
      return (trip: newTrip, isComplete: true);
    } else {
      return (trip: this, isComplete: true);
    }
  }

  bool get isComplete => startId != null && endId != null;
}

class Trip {
  final String routeId;
  final String serviceId;
  final String tripId;
  final String shapeId;
  final String tripHeadsign;
  final int directionId;
  final String? blockId;
  final int wheelchairAccessible;
  final String routeDirection;
  final String? tripNote;
  final String? bikesAllowed;
  final String departTime;
  final String arriveTime;

  Trip({
    required this.routeId,
    required this.serviceId,
    required this.tripId,
    required this.shapeId,
    required this.tripHeadsign,
    required this.directionId,
    this.blockId,
    required this.wheelchairAccessible,
    required this.routeDirection,
    this.tripNote,
    this.bikesAllowed,
    required this.departTime,
    required this.arriveTime,
  });

  factory Trip.fromRow(Map<String, dynamic> row) {
    return Trip(
      routeId: row['route_id'],
      serviceId: row['service_id'],
      tripId: row['trip_id'],
      shapeId: row['shape_id'],
      tripHeadsign: row['trip_headsign'],
      directionId: row['direction_id'],
      blockId: row['block_id'],
      wheelchairAccessible: row['wheelchair_accessible'],
      routeDirection: row['route_direction'],
      tripNote: row['trip_note'],
      bikesAllowed: row['bikes_allowed'],
      departTime: row['depart_time'],
      arriveTime: row['arrive_time'],
    );
  }
}