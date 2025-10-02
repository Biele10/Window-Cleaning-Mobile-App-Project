import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF37454a),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFF1c2a2e),
                alignment: Alignment.topCenter,
                side: BorderSide.none,
              ),
              onPressed: () {},
              child: Text(
                'Log In',
                style: TextStyle(
                  fontSize: 50,
                  fontFamily: 'FunnelDisplay',
                  foreground: Paint()
                    ..shader = ui.Gradient.linear(
                      Offset(0, 20),
                      Offset(300, 20),
                      <Color>[Colors.green, Colors.lightBlueAccent],
                    ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(30.0)),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFF1c2a2e),
                alignment: Alignment.topCenter,
                side: BorderSide.none,
              ),

              onPressed: () {},
              child: Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 50,
                  fontFamily: 'FunnelDisplay',
                  foreground: Paint()
                    ..shader = ui.Gradient.linear(
                      // gives the button the cool gradient lol
                      Offset(0, 20),
                      Offset(300, 20),
                      <Color>[Colors.green, Colors.lightBlueAccent],
                    ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
