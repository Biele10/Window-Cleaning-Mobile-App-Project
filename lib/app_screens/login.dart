import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});
  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool log_in() {
    /* this will be the function that will be called
  to log the user in, this will of course be used inside this widget but
  will also be called from the sign up widget to automatically log the user in
  once they have signed up. */

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Log In')));
  }
}
