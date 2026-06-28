import 'package:flutter/material.dart';
import 'package:tripview_2/data/databases/station_db.dart';
import 'package:tripview_2/data/models/station.dart';
import 'package:tripview_2/data/models/trip.dart';
import 'package:tripview_2/pages/routes_list.dart';
import 'package:tripview_2/pages/station_list.dart';

class ChooseRoute extends StatelessWidget {
  const ChooseRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transport Mode')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: StopType.values.map((mode) {
            return SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final UserTrip? route = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StationListPage(type: mode)),
                  );
                  if (route != null) {
                    debugPrint('${route.start}, ${route.end}');
                    final List<Trip> trips = await StationDB.instance.getTripsBetween(route.start!.stopId, route.end!.stopId);
                    if (!context.mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RouteList(
                          tripEntries: trips.toList(),
                          trip: route,
                        )
                      )
                    );
                    // debugPrint(res.first.toString());
                    // debugPrint((await StationDB.instance.getTripStops(res.first['trip_id']!)).toString());
                  }
                }, 
                child: Text(mode.label)
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}