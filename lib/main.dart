import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tripview_2/data/databases/station_db.dart';
import 'package:tripview_2/data/models/station.dart';
import 'package:tripview_2/data/models/trip.dart';
import 'package:tripview_2/pages/home_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserTripAdapter());
  Hive.registerAdapter(StationAdapter());
  await Hive.openBox<UserTrip>('saved_trips');

  await StationDB.instance.open();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: HomePage()
      ),
    );
  }
}