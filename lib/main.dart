import 'package:flutter/material.dart';
import 'package:tripview_2/data/databases/user_settings.dart';
import 'package:tripview_2/pages/home_page.dart';
import 'package:tripview_2/pages/loading.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SavedTrips.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoadingPage(),
      routes: {
        '/home': (context) => const HomePage(),
      },
    );
  }
}