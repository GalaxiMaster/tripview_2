import 'package:flutter/material.dart';
import 'package:tripview_2/data/databases/user_settings.dart';
import 'package:tripview_2/data/models/station.dart';
import 'package:tripview_2/data/models/trip.dart';
import 'package:tripview_2/pages/trip_list.dart';
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
                    if (!context.mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TripList(
                          trip: route,
                        )
                      )
                    );
                    SavedTrips.instance.addTrip(route);
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