import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>(); // can validate each form at once
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF98a2fa),
      appBar: AppBar(title: Text('Sign Up')),
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
                  decoration: const InputDecoration(hintText: 'Forename'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(40.0),
                child: TextFormField(
                  decoration: const InputDecoration(hintText: 'Surname'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(40.0),
                child: TextFormField(
                  decoration: const InputDecoration(hintText: 'Email'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(40.0),
                child: TextFormField(
                  decoration: const InputDecoration(hintText: 'Password'),
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
                  child: Text("Submit", style: TextStyle()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// List<String> hash_password(String password) {
// String hashed_password = BCrypt.hashpw(password, BCrypt.gensalt());
//}
