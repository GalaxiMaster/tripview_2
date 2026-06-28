// presentation/pages/station_list_page.dart
import 'package:flutter/material.dart';
import 'package:tripview_2/data/databases/station_db.dart';
import 'package:tripview_2/data/models/station.dart';
import 'package:tripview_2/data/models/trip.dart';

class StationListPage extends StatefulWidget {
  final StopType type;
  const StationListPage({super.key, required this.type});
  @override
  StationListPageState createState() => StationListPageState();
}

class StationListPageState extends State<StationListPage> {
  late Future<List<Station>> stationsFuture;
  final TextEditingController _searchController = TextEditingController();
  UserTrip currentTrip = UserTrip();

  @override
  void initState() {
    super.initState();
    stationsFuture = StationDB.instance.getStops(type: widget.type);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search(String query) {
    setState(() {
      stationsFuture = StationDB.instance.searchStops(query: query, type: widget.type);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.type.label)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search stations',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _search,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Station>>(
              future: stationsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final stations = snapshot.data;
                if (stations == null || stations.isEmpty) {
                  return const Center(child: Text('No stations found'));
                }

                return ListView.builder(
                  itemCount: stations.length,
                  itemBuilder: (context, index) {
                    final Station s = stations[index];
                    if (currentTrip.start == s) {
                      return SizedBox.shrink();
                    }
                    return SizedBox(
                      height: 65,
                      child: ListTile(
                        title: Text(s.stopName, maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text(
                          '${s.stopName} • ${s.stopLat.toStringAsFixed(4)}, ${s.stopLon.toStringAsFixed(4)}',
                        ),
                        onTap: () {
                          final res = currentTrip.addPart(s);
                          setState(() {
                            currentTrip = res.trip;
                          });
                          if (currentTrip.isComplete) {
                            Navigator.pop(context, currentTrip);
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}