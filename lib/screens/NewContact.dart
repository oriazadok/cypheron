import 'package:flutter/material.dart';
import 'package:cypheron/models/ContactModel.dart';
import 'package:cypheron/ui/FormUI.dart';

/// Screen to create a new contact with a name and phone number.
class NewContact extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Contact'),
      ),
      body: FormUI(
        title: 'New Contact',
        
        // Input fields for the form
        inputFields: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(labelText: 'Phone Number'),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a phone number';
              }
              return null;
            },
          ),
        ],

        // onSubmit callback for when the form is successfully submitted
        onClick: () {
          String name = _nameController.text;
          String phone = _phoneController.text;

          if (name.isNotEmpty && phone.isNotEmpty) {

            // Create new contact and return it to the previous screen
            ContactModel newContact = ContactModel(name: name, phoneNumber: phone);
            Navigator.pop(context, newContact);
          }
        },

        // Customize submit button text
        buttonText: 'Add Contact',
      ),
    );
  }
}
