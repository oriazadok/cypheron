import 'package:flutter/material.dart';

import 'package:cypheron/models/ContactModel.dart';

import 'package:cypheron/ui/widgetsUI/formUI/FormUI.dart';

import 'package:cypheron/widgets/form_elements/GenericFormField.dart';

/// A screen for creating a new contact.
/// Allows the user to input a name and phone number and save it as a `ContactModel`.
class NewContact extends StatelessWidget {
  // TextEditingController for managing the name input field.
  final TextEditingController _nameController = TextEditingController();

  // TextEditingController for managing the phone number input field.
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Main body of the screen wrapped in a reusable `FormUI` widget.
      body: FormUI(
        title: 'New Contact', // Title displayed at the top of the form.

        // Input fields for the form (Name and Phone).
        inputFields: [
          // Reusable form field for name input.
          GenericFormField(
            fieldType: FieldType.name,
            controller: _nameController,
          ),
          // Reusable form field for phone input.
          GenericFormField(
            fieldType: FieldType.phone,
            controller: _phoneController,
          ),
        ],
        
        // Callback function triggered when the "Add Contact" button is clicked.
        onClick: () {
          // Retrieve the input values from the text controllers.
          String name = _nameController.text;
          String phone = _phoneController.text;

          // Ensure both fields are filled before proceeding.
          if (name.isNotEmpty && phone.isNotEmpty) {
            // Create a new `ContactModel` instance with the entered data.
            ContactModel newContact = ContactModel(name: name, phoneNumber: phone);
            
            // Navigate back to the previous screen and return the new contact as a result.
            Navigator.pop(context, newContact);
          }
        },

        // Text displayed on the form submission button.
        buttonText: 'Add Contact',
      ),
    );
  }
}
