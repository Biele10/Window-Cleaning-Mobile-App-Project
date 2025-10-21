import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

final storage = FlutterSecureStorage(); // creates storage that is secure
bool _obscurePassword = true;

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
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email address.';
                      }
                      return null;
                    },
                    style: TextStyle(
                      color: Color(0xFFffffff),
                      fontSize: 20,
                      fontFamily: 'FunnelDisplay',
                    ),
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
                    obscureText: _obscurePassword,

                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password.';
                      }
                      return null;
                    },
                    style: TextStyle(
                      color: Color(0xFFffffff),
                      fontSize: 20,
                      fontFamily: "FunnelDisplay",
                    ),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      hintStyle: const TextStyle(
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
                    onPressed: () {
                      // log in passes build context, text in email and password
                      logIn(
                        context,
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );
                    },
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

Future<bool> validateRefresh() {}

Future<http.Response> logIn(
  BuildContext context,
  String email,
  String password,
) async {
  final http.Response response = await http.post(
    Uri.parse('http://192.168.7.150:5000/log_in'),
    headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode(<String, String>{
      // encodes all the saved data into json format
      'Email': email, // stores the users input in the
      'Password': password, // json file
    }),
  );

  if (response.statusCode == 200) {
    // log in was success

    final data = jsonDecode(response.body);

    String accToken = data['access_token'];

    String? accessTokenCheck = await storage.read(key: 'refresh_token');

    if (accessTokenCheck == null) {
      // no current access token stored

      await storage.write(key: 'access_token', value: accToken);
      // stores the new access token in Flutter Storage
    }
  }
}
