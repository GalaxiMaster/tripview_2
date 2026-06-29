import 'package:flutter/material.dart';
import 'package:tripview_2/data/databases/user_settings.dart';
import 'package:tripview_2/data/models/trip.dart';
import 'package:tripview_2/pages/choose_route.dart';
import 'package:tripview_2/pages/trip_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChooseRoute()),
                );
              },
              child: Text('New Trip'),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<UserTrip>>(
              stream: SavedTrips.instance.watchSavedTrips(),
              builder: (context, snapshot) {
                final savedTrips = snapshot.data;
                if (snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();
                if (savedTrips == null || savedTrips.isEmpty) {
                  return SizedBox.shrink();
                }
                return ListView.builder(
                  itemCount: savedTrips.length,
                  itemBuilder: (context, index) {
                    final UserTrip trip = savedTrips[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TripList(
                              trip: trip
                            )
                          )
                        );
                      },
                      child: Text('${trip.start!.stopName} -> ${trip.end!.stopName}'),
                    );
                  }
                );
              }
            ),
          )
        ],
      ),
    );
  }

}