import 'package:flutter/material.dart';
import 'package:tripview_2/data/server_data.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});
  @override
  LoadingPageState createState() => LoadingPageState();
}

class LoadingPageState extends State<LoadingPage> {
  bool hasError = false;
  double? progress;
  String status = 'Checking for updates...';

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    setState(() { hasError = false; status = 'Checking for updates...'; progress = null; });
    try {
      final needsUpdate = await Server.instance.needUpdate();
      if (needsUpdate) {
        setState(() => status = 'Downloading data...');
        await Server.instance.update(onProgress: (p) {
          if (mounted) setState(() => progress = p);
        });
      }
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } catch (e, st) {
      debugPrint('Error loading data: $e\n$st');
      if (mounted) setState(() => hasError = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: hasError
            ? [
                const Text('Error loading data. Please check your internet connection and try again.',
                    textAlign: TextAlign.center, style: TextStyle(color: Colors.red)),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: _run, child: const Text('Retry')),
              ]
            : [
                SizedBox(width: 200, child: LinearProgressIndicator(value: progress)),
                const SizedBox(height: 16),
                Text(status),
              ],
        ),
      ),
    );
  }
}