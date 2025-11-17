import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:test2/app_screens/login.dart';
import 'package:test2/app_screens/signup.dart';

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
                // styleFrom replaces the need of creating a ButtonStyle object,
                // instead visual properties can be easily altered, removes the
                // need for all the WidgetStateProperty stuff
                backgroundColor: const Color(0xFF1c2a2e), // if ButtonStyle was
                // used here, i would have to wrap Color
                // in WidgetStateProperty.all()
                alignment: Alignment.topCenter,
                side: BorderSide(width: 5),
              ),
              onPressed: () {
                Navigator.push(
                  // sends user to the log in page and pushes
                  // the account page onto the widget stack
                  context,
                  MaterialPageRoute(builder: (context) => LogIn()),
                );
              },
              child: Text(
                'Log In',
                style: TextStyle(
                  fontSize: 50,
                  fontFamily: 'FunnelDisplay',
                  foreground:
                      Paint() // essentially creates a canvas to paint on
                        ..shader = ui.Gradient.linear(
                          Offset(0, 20), // defines where the gradient starts and
                          // ends
                          Offset(300, 20),
                          <Color>[Colors.green, Colors.lightBlueAccent],
                          // defines the list of colours to be used for the
                          // gradient
                        ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(30.0)),
            OutlinedButton(
              // same as log in button
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFF1c2a2e),
                alignment: Alignment.topCenter,
                side: BorderSide(width: 5),
              ),

              onPressed: () {
                Navigator.push(
                  // sends user to the sign up page and pushes
                  // the account page onto the widget stack
                  context,
                  MaterialPageRoute(builder: (context) => SignUp()),
                );
              },
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
