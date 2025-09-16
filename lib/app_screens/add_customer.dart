import 'package:flutter/material.dart';

class AddCustomer extends StatelessWidget {
  const AddCustomer({super.key});
  @override
  Widget build(BuildContext context) {
    final fields = ["Name", "Address", "Price", "Regularity", "Phone Number"];
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Customer Details'),
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.grey[50],
      ),

      body: Column(
        children: [
          ...fields.map((label) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                decoration: InputDecoration(labelText: label),
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              maxLines: 6,
              decoration: InputDecoration(
                labelText: "Additional Information",
                alignLabelWithHint: true,
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              child: Icon(Icons.add),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(65, 60)),
                maximumSize: MaterialStateProperty.all(Size(65, 60)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
