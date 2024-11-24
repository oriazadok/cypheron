import 'package:flutter/material.dart';
import 'package:cypheron/models/ContactModel.dart';
import 'package:cypheron/ui/widgetsUI/formUI/FormUI.dart';
import 'package:cypheron/widgets/form_elements/GenericFormField.dart';

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
          GenericFormField.getFormField(
                type: 'name',
                controller: _nameController,
              ),
              GenericFormField.getFormField(
                type: 'phone',
                controller: _phoneController,
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
