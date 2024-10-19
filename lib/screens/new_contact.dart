import 'package:flutter/material.dart';

class NewContact extends StatefulWidget {
  @override
  _NewContactState createState() => _NewContactState();
}

class _NewContactState extends State<NewContact> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String name = _nameController.text;
                String phone = _phoneController.text;

                if (name.isNotEmpty && phone.isNotEmpty) {
                  // Save the contact (this could involve saving to a database or local storage)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Contact $name added')),
                  );
                  Navigator.pop(context);  // Return to previous screen
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill in all fields')),
                  );
                }
              },
              child: Text('Add Contact'),
            ),
          ],
        ),
      ),
    );
  }
}
