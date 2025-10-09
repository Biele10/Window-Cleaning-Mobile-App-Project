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
      appBar: AppBar(title: Text('Sign Up')),
      body: Form(
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
                decoration: const InputDecoration(hintText: 'Email'),
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
                decoration: const InputDecoration(hintText: 'Email'),
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
              child: OutlinedButton(child: Text("Jere"), onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }
}

// List<String> hash_password(String password) {
// String hashed_password = BCrypt.hashpw(password, BCrypt.gensalt());
//}
