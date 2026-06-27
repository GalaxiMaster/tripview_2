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
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChooseRoute()),
            );
          },
          child: Text('New Trip'),
        )
      ],
    );
  }

}