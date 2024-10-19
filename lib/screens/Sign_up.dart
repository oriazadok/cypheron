import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:crypto/crypto.dart';  // Import for password hashing
import 'dart:convert'; // Import for converting strings to bytes
import 'Home.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String hashPassword(String password) {
    final bytes = utf8.encode(password); // Convert password to bytes
    final hashed = sha256.convert(bytes); // Perform SHA-256 hashing
    return hashed.toString(); // Return the hashed password
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true, // Password is hidden
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String username = _usernameController.text;
                String password = _passwordController.text;

                if (username.isNotEmpty && password.isNotEmpty) {
                  var box = Hive.box('secureBox');

                  // Check if the user already exists
                  if (box.get(username) != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Username already exists')),
                    );
                    return;
                  }

                  // Hash the password before storing it
                  String hashedPassword = hashPassword(password);

                  // Save the username and hashed password in Hive
                  await box.put(username, hashedPassword);

                  // Navigate to Home Screen after successful sign-up
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Home(username: _usernameController.text),),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill in all fields')),
                  );
                }
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
