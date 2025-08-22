import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ICH BIN REICH'),
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        foregroundColor: Colors.grey[50],
      ),
      backgroundColor: Colors.blueGrey,
      body: Center(child: Image.asset("images/brain.jpg")),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
