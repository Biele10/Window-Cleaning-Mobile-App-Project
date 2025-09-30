import 'package:flutter/material.dart';
import 'package:test2/app_screens/first_screen.dart';
import 'package:test2/utilities/common_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: MyFlutterApp()),
  );
}

class MyFlutterApp extends StatefulWidget {
  const MyFlutterApp({super.key});

  @override
  State<MyFlutterApp> createState() => _MyFlutterAppState();
}

class _MyFlutterAppState extends State<MyFlutterApp> {
  bool? connectivityStatus;

  @override
  void initState() {
    super.initState();
    check_connectivity();
  }

  Future<void> check_connectivity() async {
    internet_check ic =
        internet_check(); // creates an instance of internet_check class
    bool connection_result = await ic.is_connected();
    setState(() {
      connectivityStatus = connection_result;
    });

    if (!connection_result && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text("No internet connection."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                check_connectivity(); // allows user to enable internet and try again
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    } else if (connection_result && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FirstScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: Colors.white);
  }
}
