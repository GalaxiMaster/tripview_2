// Save
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tripview_2/data/models/trip.dart';

class SavedTrips {
  SavedTrips._();
  static final SavedTrips instance = SavedTrips._();

  Box<UserTrip> get box => Hive.box<UserTrip>('saved_trips');

  List<UserTrip> getTrips() {
    return box.values.toList();
  }

  Future<void> addTrip(UserTrip trip) async {
    await box.add(trip);
  }

  Future<void> deleteTrip(UserTrip trip) async {
    await trip.delete();
  }
}