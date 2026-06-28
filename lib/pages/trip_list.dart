import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tripview_2/data/databases/station_db.dart';
import 'package:tripview_2/data/models/trip.dart';

class TripList extends StatefulWidget {
  final UserTrip trip;
  const TripList({super.key, required this.trip});

  @override
  TripListState createState() => TripListState();
}

class TripListState extends State<TripList> {
  late final ScrollController _controller;
  late final int _firstFutureIndex;
  static const double _itemHeight = 60;
  TimeOfDay now = TimeOfDay.now();
  late Timer _timer;
  late final Future<List<Trip>> tripsFuture;

  @override
  void initState() {
    super.initState();
    getTrips();
    _scheduleNextTick();
  }
  void getTrips() async{
    tripsFuture = StationDB.instance.getTripsBetween(widget.trip.start!.stopId, widget.trip.end!.stopId);
    final trips = await tripsFuture;
    _firstFutureIndex = trips.indexWhere((trip) {
      final parts = trip.departTime.split(':');
      final h = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      return h > now.hour || (h == now.hour && m >= now.minute);
    });

    _controller = ScrollController(
      initialScrollOffset: _firstFutureIndex > 0
        ? _firstFutureIndex * _itemHeight
        : 0.0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }
  void _scheduleNextTick() {
    _timer = Timer(Duration(seconds: 60 - DateTime.now().second), () {
      if (!mounted) return;
      setState(() => now = TimeOfDay.now());
      _scheduleNextTick();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(widget.trip.start!.stopName),
            Text(widget.trip.end!.stopName),
          ],
        ),
      ),
      body: FutureBuilder(
        future: tripsFuture,
        builder: (context, future) {
          if (future.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          final trips = future.data!;
          return ListView.builder(
            controller: _controller,
            itemCount: trips.length,
            itemExtent: _itemHeight,
            itemBuilder: (context, index) {
              final trip = trips[index];
          
              final parts = trip.departTime.split(':');
              final h = int.parse(parts[0]);
              final m = int.parse(parts[1]);
              final diff = (h*60 - now.hour*60 + m - now.minute);
              final isPast = diff < 0;
          
              return SizedBox(
                height: _itemHeight,
                child: Row(
                  children: [
                    Container(
                      height: _itemHeight,
                      width: _itemHeight,
                      color: isPast ? Colors.blue.withValues(alpha: 150) : Colors.blue,
                      padding: EdgeInsets.all(4),
                      child: Center(child: Text(
                        !isPast ? '${diff.abs()} mins' : '${diff.abs()} mins ago'
                      )),
                    ),
                    Row(
                      spacing: 20,
                      children: [
                        Text(
                          trip.departTime,
                          style: TextStyle(color: isPast ? Colors.grey : null),
                        ),
                        Text(
                          trip.arriveTime,
                          style: TextStyle(color: isPast ? Colors.grey : null),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        }
      ),
    );
  }
}