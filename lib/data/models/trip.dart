class Trip {
  final String? startId;
  final String? endId;
  Trip({this.startId, this.endId});
  
  Trip copyWith({
    String? startId,
    String? endId,
  }) {
    return Trip(
      startId: startId ?? this.startId, 
      endId: endId ?? this.endId
    );
  }

  ({Trip trip, bool isComplete}) addPart(String id) {
    if (startId == null) {
      final newTrip = Trip(startId: id);
      return (trip: newTrip, isComplete: false);
    } else if (endId == null) {
      final newTrip = Trip(startId: startId, endId: id);
      return (trip: newTrip, isComplete: true);
    } else {
      return (trip: this, isComplete: true);
    }
  }

  bool get isComplete => startId != null && endId != null;
}