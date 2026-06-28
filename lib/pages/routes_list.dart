import 'package:flutter/material.dart';
import 'package:tripview_2/data/models/trip.dart';

class RouteList extends StatefulWidget {
  final List<Trip> tripEntries;
  final UserTrip trip;
  const RouteList({super.key, required this.tripEntries, required this.trip});

  @override
  RouteListState createState() => RouteListState();
}

class RouteListState extends State<RouteList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(widget.trip.startId!),
            Text(widget.trip.endId!),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: widget.tripEntries.length,
        itemBuilder: (context, index) {
          final Trip trip = widget.tripEntries[index];
          return Row(
            spacing: 20,
            children: [
              Text(trip.departTime),
              Text(trip.arriveTime)
            ],
          );
        },
      ),
    );
  }

}