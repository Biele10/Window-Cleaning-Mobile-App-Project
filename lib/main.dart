import 'package:flutter/material.dart';
import 'package:test2/app_screens/first_screen.dart';

// the main function is the starting point for all flutter apps, like OnApp in C++
void main() => runApp(MyFlutterApp());

class MyFlutterApp extends StatelessWidget {
  const MyFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "test app",
      home: Scaffold(body: FirstScreen()),
    );
  }
}
