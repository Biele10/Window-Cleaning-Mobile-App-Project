import 'package:flutter/material.dart';
import 'package:test2/app_screens/account.dart';
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
    bool connectionResult = await ic.is_connected();
    setState(() {
      connectivityStatus = connectionResult;
    });

    if (!connectionResult && mounted) {
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
    } else if (connectionResult && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AccountPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sponge',
      theme: ThemeData(
        fontFamily: 'FunnelDisplay',
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF4f4b4c), width: 2.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
      ),
    );
  }
}
