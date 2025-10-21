import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage(); // creates storage that is secure

class LogIn extends StatefulWidget {
  const LogIn({super.key});
  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>(); // can validate each form at once
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController(); // controller access
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF37454a),
      appBar: AppBar(
        title: Text(
          'Log In',
          style: TextStyle(
            color: Color(0xFF000000),
            fontFamily: 'FunnelDisplay',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,

          child: SizedBox(
            height: MediaQuery.of(context).size.height, // takes size of screen
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(40.0, 0, 40.0, 25),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email address.';
                      }
                      return null;
                    },
                    style: TextStyle(color: Color(0xFFffffff)),
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        color: Color(0xFFffffff),
                        fontSize: 20,
                        fontFamily: 'FunnelDisplay',
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(40.0, 100, 40.0, 95),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password.';
                      }
                      return null;
                    },
                    style: TextStyle(color: Color(0xFFffffff)),
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        color: Color(0xFFffffff),
                        fontSize: 20,
                        fontFamily: 'FunnelDisplay',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(17.0),
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      minimumSize: (Size(45, 50)),
                      side: BorderSide(width: 5.0),
                      backgroundColor: Color(0xFF1c2a2e),
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Color(0xFFffffff), fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> saveAccessToken(String token) async {
  await storage.write(key: 'access_token', value: token);
  // stores the access token securely
}

Future log_in(String email, String password) async {
  // two parameters

  return true;
}
