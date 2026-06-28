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
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              final UserTrip? route = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StationListPage(type: StopType.train)),
              );
              if (route != null) {
                debugPrint('${route.startId}, ${route.endId}');
                final List<Trip> trips = await StationDB.instance.getTripsBetween(route.startId!, route.endId!);
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
            child: Text('Trains')
          )
        ],
      ),
    );
  }
}