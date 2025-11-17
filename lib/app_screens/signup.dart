import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

bool _obscurePassword = true;

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
        title: Text(
          'Sign Up',
          style: TextStyle(
            color: Color(0xFF000000),
            fontFamily: 'FunnelDisplay',
          ),
        ),
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your forename.';
                    }
                    return null;
                  },
                  style: TextStyle(
                    color: Color(0xFFffffff),
                    fontSize: 20,
                    fontFamily: "FunnelDisplay",
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Forename',
                    hintStyle: TextStyle(
                      color: Color(0xFFffffff),
                      fontSize: 20,
                      fontFamily: 'FunnelDisplay',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(40.0),
                child: TextFormField(
                  controller: _surnameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your surname.';
                    }
                    return null;
                  },
                  style: TextStyle(
                    color: Color(0xFFffffff),
                    fontSize: 20,
                    fontFamily: 'FunnelDisplay',
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Surname',
                    hintStyle: TextStyle(
                      color: Color(0xFFffffff),
                      fontSize: 20,
                      fontFamily: 'FunnelDisplay',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(40.0),
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
                padding: EdgeInsets.all(40.0),
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
                    fontFamily: 'FunnelDisplay',
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
                  onPressed: () {
                    if (!mounted) {
                      // ensures that widget has loaded
                      return;
                    }

                    final formValidate = _formKey.currentState!.validate();

                    if (!formValidate) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          // small pop up at bottom of screen temporarily
                          content: Text(
                            'Please enter all the information for each field.',
                          ),
                        ),
                      );
                    } else {
                      signUp(
                        context, // passes through controllers and context
                        // for the current widget
                        _emailController,
                        _passwordController,
                        _forenameController,
                        _surnameController,
                      );
                    }
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
    );
  }
}

Future<http.Response> signUp(
  BuildContext context,
  // future is a data type that means that
  // the value that is to be returned may not come back instantly so,
  // the operation is asynchronous meaning other operations can run while the
  // function is running

  // function that converts user input into json format
  TextEditingController email, // passes the controllers through so they
  // can be accessed within function
  TextEditingController password,
  TextEditingController forename,
  TextEditingController surname,
) async {
  final http.Response response = await http.post(
    /* http post only returns a
  Future<http.Response>, so when i try to assign this variable to just a
  http.Response class, it doesn't work as the types don't match, therefore
  the key word 'await' is used, this says to the 'response' variable to wait
  for the Future to finish, and once it has a http.Response is produced. */
    Uri.parse('http://192.168.1.231:5000/sign_up'), // url of server to send
    // data to
    headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode(<String, String>{
      // encodes all the saved data into json format
      'Email': email.text.trim(), // stores the users input in the
      'Password': password.text.trim(), // json file
      'Forename': forename.text.trim(),
      'Surname': surname.text.trim(),
    }),
  );

  final data = jsonDecode(response.body);

  if (response.statusCode == 200) {
    // status code 200 indicates success
    // response is positive
    String logInEmail = email.text.trim();
    String logInPassword = password.text.trim();
    // stores the email and
    //password  to be passed into the login function
    forename.clear();
    surname.clear(); // only clears the fields once the server has
    // successfully added the user to the database
    email.clear();
    password.clear();

    final storage = FlutterSecureStorage();

    String newRefToken = data['refresh_token'];

    await storage.write(key: 'refresh_token', value: newRefToken);

    ScaffoldMessenger.of(context).showSnackBar(
      // context refers to the previous
      // widget in the widget tree, for this reason BuildContext context
      // is passed through as a parameter into this function
      SnackBar(
        content: Text('Signed up successfully!'), // user signs up
      ),
    );
  } else if (response.statusCode == 400) {
    // status code 400 indicates error

    String errorMessage = data['message']; // extracts the error message from the
    // decoded json

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // SnackBar can't be constant because the error message
        // may change depending on the error
        // displays the issue the user is having
        content: Text(errorMessage), // displays error message for user
      ),
    );
  }
  return response;
}
