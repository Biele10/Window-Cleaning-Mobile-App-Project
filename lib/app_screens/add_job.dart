import 'package:flutter/material.dart';

class AddJob extends StatefulWidget {
  const AddJob({super.key});
  @override
  State<AddJob> createState() => _AddJobState();
}

class _AddJobState extends State<AddJob> {
  @override
  Widget build(BuildContext context) {
    return (Form(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Add Job"),
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.grey[50],
        ),
      ),
    ));
  }
}
