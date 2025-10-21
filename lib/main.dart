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
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    InternetCheck ic =
        InternetCheck(); // creates an instance of internet_check class
    bool connectionResult = await ic.isConnected();
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
                checkConnectivity(); // allows user to enable internet and try again
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
      debugShowCheckedModeBanner: false,
      title: 'Sponge',
      theme: ThemeData(
        fontFamily: 'FunnelDisplay',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontFamily: 'FunnelDisplay',
          ),
          titleLarge: TextStyle(color: Colors.red),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF4f4b4c), width: 2.0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),

        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(
            color: Colors.white70, // default hint text color
            fontSize: 20, // default hint text size
            fontFamily: 'FunnelDisplay', // default hint font
          ),
          border: OutlineInputBorder(), // optional default border
        ),
      ),
    );
  }
}
