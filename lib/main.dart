import 'package:flutter/material.dart';
import 'package:tripview_2/data/databases/station_db.dart';
import 'package:tripview_2/data/models/station.dart';
import 'package:tripview_2/pages/station_list.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await StationDB.instance.open();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder(
          future: StationDB.instance.getStops(type: StopType.train),
          builder: (context, future) {
            if (future.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            return StationListPage(stations: future.data!);
          }
        )
      ),
    );
  }
}