import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddJob extends StatefulWidget {
  const AddJob({super.key});
  @override
  State<AddJob> createState() => _AddJobState();
}

class _AddJobState extends State<AddJob> {
  // able to access user inputs
  final _customerController = TextEditingController();
  final _timeController = TextEditingController();
  final _dateController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Job"),
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.grey[50],
      ),
      body: Form(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextFormField(decoration: InputDecoration(hintText: "Date")),

                TextFormField(decoration: InputDecoration(hintText: "Time")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<http.Response> createAlbum(
  // function that converts a job into a json and stores it in the job file
  String name,
  String address,
  String regularity,
  String emailAddress,
  String phoneNumber,
  String addInfo,
) {
  return http.post(
    Uri.parse('http://192.168.1.231:5000/add_customer'),
    headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode(<String, String>{
      // encodes all the saved data into json format
      'RequestType': 'add_customer', // tells the server the type of request
      'Name': name,
      'Address': address,
      'Regularity': regularity,
      'Email': emailAddress,
      'Phone': phoneNumber,
      'AddInfo': addInfo,
    }),
  );
}
