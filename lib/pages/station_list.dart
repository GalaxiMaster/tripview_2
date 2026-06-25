// presentation/pages/station_list_page.dart
import 'package:flutter/material.dart';
import 'package:tripview_2/data/models/station.dart';

class StationListPage extends StatelessWidget {
  final List<Station> stations;

  const StationListPage({super.key, required this.stations});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NSW Train Stations')),
      body: ListView.builder(
        itemCount: stations.length,
        itemExtent: 65.0,
        itemBuilder: (context, index) {
          final Station s = stations[index];
          return ListTile(
            title: Text(s.stopName, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(
              '${s.stopName} • ${s.stopLat.toStringAsFixed(4)}, ${s.stopLon.toStringAsFixed(4)}',
            ),
            onTap: () => _navigateToRealTimeLineView(context, s),
          );
        },
      ),
    );
  }

  void _navigateToRealTimeLineView(BuildContext context, Station station) {
    // Phase 2: query real-time API using station.stopId
  }
}