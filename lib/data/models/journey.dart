import 'package:tripview_2/data/models/trip.dart';

class Journey {
  final List<Trip> legs;
  final List<String> interchangeNames; // one per transfer

  const Journey({required this.legs, required this.interchangeNames});

  factory Journey.fromLegs(List<Trip> legs, String interchangeName) =>
    Journey(legs: legs, interchangeNames: [interchangeName]);

  bool get isDirect => legs.length == 1;
  int get transfers => legs.length - 1;
  String get departTime => legs.first.departTime;
  String get arriveTime => legs.last.arriveTime;
}