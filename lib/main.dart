import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:test2/app_screens/account.dart';
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
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    InternetCheck ic =
        InternetCheck(); // creates an instance of internet_check class
    bool connectionResult = await ic.isConnected();
    setState(() {
      connectivityStatus = connectionResult;
    });

    final storage = FlutterSecureStorage();
    String? accTokenCheck = await storage.read(key: 'access_token');
    String? refreshTokenCheck = await storage.read(key: 'refresh_token');
    bool isAccessTokenExpired(String? token) {
      // decodes jwt

      if (token == null || token.isEmpty) {
        return true;
      }
      try {
        final parts = token.split('.');
        if (parts.length != 3) return true;

        final payload = jsonDecode(
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
        );

        final exp = payload['exp'];
        final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

        return exp < now;
      } catch (_) {
        return true; // if decode fails, treat as expired
      }
    }

    Future<bool> verifyRefreshToken() async {
      String? userID = await storage.read(key: 'user_id');

      print(refreshTokenCheck);
      print(userID);

      final http.Response response = await http.post(
        Uri.parse('http://192.168.1.231:5000/verify_refresh_token'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String?>{
          // encodes all the saved data into json format
          'UserID': userID,
          'RefreshToken': refreshTokenCheck,
        }),
      );

      if (response.statusCode == 400) {
        final data = jsonDecode(response.body);

        String? err = data['message'];

        print(err);
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        String newRefToken = data['refresh_token'];

        print("we got here dwag");
        await storage.write(key: 'refresh_token', value: newRefToken);

        final http.Response accessResponse = await http.post(
          Uri.parse('http://192.168.1.231:5000/generate_access_token'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String?>{'UserID': userID}),
        );

        if (accessResponse.statusCode == 200) {
          // gets access token
          final accessData = jsonDecode(accessResponse.body);

          String newAccessToken = accessData['access_token'];

          print(newAccessToken);

          await storage.write(key: 'access_token', value: newAccessToken);

          return true;
        } else {
          return false;
        }
      }
      return false;
    }

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
      if (accTokenCheck == null || isAccessTokenExpired(accTokenCheck)) {
        if (await verifyRefreshToken()) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => FirstScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AccountPage()),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FirstScreen()),
        );
      }
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
