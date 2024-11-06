import 'package:flutter/material.dart';
import 'package:cypheron/models/ContactModel.dart';

/// Screen to create a new contact with a name and phone number
class NewContact extends StatefulWidget {
  @override
  _NewContactState createState() => _NewContactState();
}

class _NewContactState extends State<NewContact> {
  // Controllers to manage input fields for name and phone number
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Contact'),  // Title for the screen
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),  // Add padding around content
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,  // Center contents vertically
          children: [
            // TextField for entering the contact name
            TextField(
              controller: _nameController,  // Attach controller to capture input
              decoration: InputDecoration(labelText: 'Name'),  // Label for the input field
            ),
            SizedBox(height: 20),  // Add vertical space

            // TextField for entering the contact phone number
            TextField(
              controller: _phoneController,  // Attach controller to capture input
              decoration: InputDecoration(labelText: 'Phone Number'),  // Label for the input field
              keyboardType: TextInputType.phone,  // Display numeric keyboard for phone input
            ),
            SizedBox(height: 20),  // Add vertical space

            // Button to add the new contact
            ElevatedButton(
              onPressed: () {
                String name = _nameController.text;  // Get the name from input
                String phone = _phoneController.text;  // Get the phone number from input

                if (name.isNotEmpty && phone.isNotEmpty) {
                  // If both fields are filled, proceed to add contact
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Contact $name added')),  // Confirmation message
                  );

                  // Create a new ContactModel instance with provided details
                  ContactModel newContact = ContactModel(name: name, phoneNumber: phone);

                  // Return the new contact to the previous screen
                  Navigator.pop(context, newContact);
                } else {
                  // Show error message if any field is left empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill in all fields')),
                  );
                }
              },
              child: Text('Add Contact'),  // Button label
            ),
          ],
        ),
      ),
    );
  }
}
