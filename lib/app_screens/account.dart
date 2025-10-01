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
            Text(
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
            Padding(padding: EdgeInsets.all(20.0)),
            ElevatedButton(
              style: ButtonStyle(alignment: Alignment.topCenter),
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
