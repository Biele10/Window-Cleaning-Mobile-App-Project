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
  final _addInfoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF37454a),

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
                // contains list of all TextFormField widgets
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    style: TextStyle(
                      color: Color(0xFFffffff),
                      fontSize: 18,
                      fontFamily: "FunnelDisplay",
                    ),
                    controller:
                        _customerController, // allows for text that is entered
                    // within a textbox to be retrieved
                    decoration: InputDecoration(
                      hintText: 'Customer',
                      hintStyle: TextStyle(
                        color: Color(0xFFffffff),
                        fontSize: 18,
                        fontFamily: 'FunnelDisplay',
                      ),
                    ), // hint text to tell user what to
                    // type in there
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    style: TextStyle(
                      color: Color(0xFFffffff),
                      fontSize: 18,
                      fontFamily: "FunnelDisplay",
                    ),
                    controller: _timeController,
                    decoration: InputDecoration(
                      hintText: 'Time',
                      hintStyle: TextStyle(
                        color: Color(0xFFffffff),
                        fontSize: 18,
                        fontFamily: 'FunnelDisplay',
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        // used in order to verify whether
                        // the user has entered any information at all
                        return 'This detail is required.';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    style: TextStyle(
                      color: Color(0xFFffffff),
                      fontSize: 18,
                      fontFamily: "FunnelDisplay",
                    ),
                    controller: _dateController,
                    decoration: InputDecoration(
                      hintText: 'Date',
                      hintStyle: TextStyle(
                        color: Color(0xFFffffff),
                        fontSize: 18,
                        fontFamily: 'FunnelDisplay',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    style: TextStyle(
                      color: Color(0xFFffffff),
                      fontSize: 18,
                      fontFamily: "FunnelDisplay",
                    ),
                    controller:
                        _priceController, // allows for text that is entered
                    // within a textbox to be retrieved
                    decoration: InputDecoration(
                      hintText: 'Price',
                      hintStyle: TextStyle(
                        color: Color(0xFFffffff),
                        fontSize: 18,
                        fontFamily: 'FunnelDisplay',
                      ),
                    ), // hint text to tell user what to
                    // type in there
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    style: TextStyle(
                      color: Color(0xFFffffff),
                      fontSize: 18,
                      fontFamily: "FunnelDisplay",
                    ),
                    controller: _addInfoController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: "Additional Information",
                      hintStyle: TextStyle(
                        color: Color(0xFFffffff),
                        fontSize: 18,
                        fontFamily: 'FunnelDisplay',
                      ),
                      alignLabelWithHint: true,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(17.0),
                  child: Center(
                    child: ElevatedButton(
                      // + button at bottom of screen
                      // to submit information
                      onPressed: () {
                        return;
                      },
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all(Size(65, 60)),
                        maximumSize: WidgetStateProperty.all(Size(65, 60)),
                      ),
                      child: Icon(Icons.add),
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
