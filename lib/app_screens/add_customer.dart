import 'package:flutter/material.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({super.key});
  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _regularityController = TextEditingController();
  final _additionalinfoController = TextEditingController();
  // allows for each individual text box to be accessed
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Customer Details'),
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.grey[50],
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This detail is required.';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(labelText: 'Address'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This detail is required.';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: _regularityController,
                    decoration: InputDecoration(labelText: 'Regularity'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email Address'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: _additionalinfoController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      labelText: "Additional Information",
                      alignLabelWithHint: true,
                    ),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      final formValidate = _formKey.currentState!.validate();
                      final phoneEmpty = _phoneController.text.trim().isEmpty;
                      final emailEmpty = _emailController.text.trim().isEmpty;

                      if (formValidate && phoneEmpty && emailEmpty) {
                        // checks to see if either email is empty,
                        // phone or rest of the required fields
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please enter either a phone number or email.',
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Data is being processed...'),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
