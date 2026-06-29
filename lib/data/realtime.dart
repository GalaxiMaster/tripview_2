import 'package:gtfs_realtime_bindings/gtfs_realtime_bindings.dart';
import 'package:http/http.dart' as http;

class RealtimeService {
  static const _apiKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIweC1vR25DelZRdlk4cUZxZm1yRmhrSl9jZzc3d05ueENBLXF3R1JTNGlvIiwiaWF0IjoxNzgyMzYyMTIyfQ.2p0Dt0xE_ePWEggmRUaR5Tl9DEYMSzMmzUZtaM7Ow2I';
  static const _sydneyTrainsUrl = 'https://api.transport.nsw.gov.au/v2/gtfs/realtime/sydneytrains';

  Future<Map<String, TripRealtimeData>> getRealtimeForTrips(
    Set<String> tripIds,
  ) async {
    final response = await http.get(
      Uri.parse(_sydneyTrainsUrl),
      headers: {'Authorization': 'apikey $_apiKey'},
    );

    if (response.statusCode != 200) {
      throw Exception('Realtime API error: ${response.statusCode}');
    }

    final feed = FeedMessage.fromBuffer(response.bodyBytes);
    final results = <String, TripRealtimeData>{};

    for (final entity in feed.entity) {
      if (!entity.hasTripUpdate()) continue;

      final update = entity.tripUpdate;
      final tripId = update.trip.tripId;

      // Include ALL trips in the feed, not just ones we asked for —
      // presence in the feed means the trip is currently active
      if (!tripIds.contains(tripId)) continue;

      final stopDelays = <String, int>{};
      for (final stu in update.stopTimeUpdate) {
        final delay = stu.hasDeparture()
            ? stu.departure.delay
            : stu.arrival.delay;
        if (delay != 0) stopDelays[stu.stopId] = delay; // only store actual delays
      }

      results[tripId] = TripRealtimeData(
        tripId: tripId,
        scheduleRelationship: update.trip.scheduleRelationship,
        stopDelays: stopDelays,
        hasRealtimeData: true,
      );
    }

    return results;
  }
}

class TripRealtimeData {
  final String tripId;
  final TripDescriptor_ScheduleRelationship scheduleRelationship;
  final Map<String, int> stopDelays;
  final bool hasRealtimeData; // false = not in feed yet, true = active

  bool get isCancelled =>
      scheduleRelationship == TripDescriptor_ScheduleRelationship.CANCELED;

  bool get isOnTime =>
      hasRealtimeData && !isCancelled && stopDelays.isEmpty;

  int delayAtStop(String stopId) => stopDelays[stopId] ?? 0;

  const TripRealtimeData({
    required this.tripId,
    required this.scheduleRelationship,
    required this.stopDelays,
    this.hasRealtimeData = true,
  });
}