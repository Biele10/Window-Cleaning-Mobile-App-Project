import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>(); // can validate each form at once
  final _forenameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF37454a),
      appBar: AppBar(
        title: Text('Sign Up', style: TextStyle(color: Color(0xFF000000))),
      ),
      body: SingleChildScrollView(
        // if screen is too small, user can scroll
        // to fill in whole form and submit
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 40.0,
                  right: 40.0,
                  bottom: 40.0,
                  top: 50.0,
                ),
                child: TextFormField(
                  controller: _forenameController,
                  style: TextStyle(color: Color(0xFFffffff)),
                  decoration: const InputDecoration(
                    hintText: 'Forename',
                    hintStyle: TextStyle(color: Color(0xFFffffff)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(40.0),
                child: TextFormField(
                  controller: _surnameController,
                  style: TextStyle(color: Color(0xFFffffff)),
                  decoration: const InputDecoration(
                    hintText: 'Surname',
                    hintStyle: TextStyle(color: Color(0xFFffffff)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(40.0),
                child: TextFormField(
                  controller: _emailController,
                  style: TextStyle(color: Color(0xFFffffff)),
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Color(0xFFffffff)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(40.0),
                child: TextFormField(
                  controller: _passwordController,
                  style: TextStyle(color: Color(0xFFffffff)),
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Color(0xFFffffff)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(17.0),
                child: OutlinedButton(
                  onPressed: () {
                    createAlbum(
                      // .trim removes whitespace
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                      _forenameController.text.trim(),
                      _surnameController.text.trim(),
                    );
                    _forenameController.clear();
                    _surnameController.clear();
                    _emailController.clear();
                    _passwordController.clear();
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: (Size(45, 50)),
                    side: BorderSide(width: 5.0),
                    backgroundColor: Color(0xFF1c2a2e),
                  ),
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Color(0xFFffffff)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<http.Response> createAlbum(
  // future is a data type that means that
  // the value that is to be returned may not come back instantly so,
  // the operation is asynchronous meaning other operations can run while the
  // function is running

  // function that converts user input into json format
  String forename,
  String surname,
  String email,
  String password,
) {
  final response = http.post(
    Uri.parse('http://192.168.7.150:5000/sign_up'), // url of server to send
    // data to
    headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode(<String, String>{
      // encodes all the saved data into json format
      'Email': email,
      'Password': password,
      'Forename': forename,
      'Surname': surname,
    }),
  );

  if (response.statusCode == 200) {
    // response is positive

    final data = jsonDecode(response.body); // data is decoded from json format
  }
}

// List<String> hash_password(String password) {
// String hashed_password = BCrypt.hashpw(password, BCrypt.gensalt());
//}
