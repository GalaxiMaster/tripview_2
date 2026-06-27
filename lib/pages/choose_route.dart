import 'package:flutter/material.dart';
import 'package:tripview_2/data/models/station.dart';
import 'package:tripview_2/data/models/trip.dart';
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
              final Trip? route = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StationListPage(type: StopType.train)),
              );
              if (route != null) {
                debugPrint('${route.startId}, ${route.endId}');
              }
            }, 
            child: Text('Trains')
          )
        ],
      ),
    );
  }
}