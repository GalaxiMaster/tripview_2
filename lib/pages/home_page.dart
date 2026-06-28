import 'package:flutter/material.dart';
import 'package:tripview_2/pages/choose_route.dart';

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
              child: Expanded(child: Text('New Trip')),
            ),
          )
        ],
      ),
    );
  }

}