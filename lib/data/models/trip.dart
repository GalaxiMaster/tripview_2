import 'package:hive_flutter/adapters.dart';
import 'package:tripview_2/data/models/station.dart';

part 'trip.g.dart';

@HiveType(typeId: 0)
class UserTrip extends HiveObject{
  @HiveField(0) late Station? start;
  @HiveField(1) late Station? end;
  UserTrip({this.start, this.end});
  
  UserTrip copyWith({
    Station? start,
    Station? end,
  }) {
    return UserTrip(
      start: start ?? this.start, 
      end: end ?? this.end
    );
  }

  ({UserTrip trip, bool isComplete}) addPart(Station id) {
    if (start == null) {
      final newTrip = UserTrip(start: id);
      return (trip: newTrip, isComplete: false);
    } else if (end == null) {
      final newTrip = UserTrip(start: start, end: id);
      return (trip: newTrip, isComplete: true);
    } else {
      return (trip: this, isComplete: true);
    }
  }

  bool get isComplete => start != null && end != null;
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