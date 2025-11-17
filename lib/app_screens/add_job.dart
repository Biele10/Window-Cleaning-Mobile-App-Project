import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AddJob extends StatefulWidget {
  const AddJob({super.key});
  @override
  State<AddJob> createState() => _AddJobState();
}

class _AddJobState extends State<AddJob> {
  // able to access user inputs
  final _customerController = TextEditingController();
  final _priceController = TextEditingController();
  final _addInfoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime currentDate = DateTime.now();
  dynamic curTime = 'Select a Time';
  dynamic curDate = 'Select a Date';

  @override
  Widget build(BuildContext context) {
    final hours = currentDate.hour.toString().padLeft(2, '0');
    final minutes = currentDate.minute.toString().padLeft(2, '0');
    final DateFormat formatter =
        DateFormat.yMMMd(); // sets the format for the date
    dynamic dateToDisplay = (curDate == 'Select a Date')
        ? curDate
        : formatter.format(DateUtils.dateOnly(curDate));

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
                  child: ElevatedButton(
                    onPressed: () async {
                      final time = await chooseTime();
                      if (time == null) {
                        return;
                      } else {
                        String timeString = time.toString();
                        curTime = timeString.substring(
                          timeString.indexOf('(') + 1,
                          timeString.indexOf(')'),
                        );
                        setState(() {});
                      }
                    },
                    child: Text(curTime.toString()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      final date = await chooseDate();
                      if (date == null) {
                        return;
                      } else {
                        curDate = date;
                        setState(() {});
                      }
                    },

                    child: Text(dateToDisplay),
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
                        }
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

  Future<DateTime?> chooseDate() => showDatePicker(
    context: context,
    initialDate: currentDate,
    firstDate: currentDate,
    lastDate: DateTime(2100),
  );

  Future<TimeOfDay?> chooseTime() => showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: currentDate.hour, minute: currentDate.minute),
  );
}

Future<http.Response> createAlbum(
  // function that converts a job into a json and stores it in the job file
  String name,
  String address,
  String regularity,
  String emailAddress,
  String phoneNumber,
  String addInfo,
) async {
  final storage = FlutterSecureStorage();

  String? accessToken = await storage.read(key: 'access_token');
  return http.post(
    Uri.parse('http://192.168.1.231:5000/add_job'),
    headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode(<String, String?>{
      // encodes all the saved data into json format
      'CustomerID': 'temp',
      'access_token': accessToken,
      'Time': address,
      'Date': regularity,
      'Price': emailAddress,
      'Timezone': phoneNumber,
      'AddInfo': addInfo,
    }),
  );
}
