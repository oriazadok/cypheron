import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';  // For hashing
import 'dart:convert';  // For UTF8 encoding
import 'package:cypheron/services/HiveService.dart';  // Import the Hive service
import 'package:cypheron/models/UserModel.dart';  // Import the UserModel
import 'package:cypheron/screens/Home.dart'; // The UserModel

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();  // Form key to validate the form
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String errorMessage = '';  // To display errors

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email input field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Password input field
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Display error message if there is one
              if (errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 20),
              // Sign In button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    UserModel? signInSuccessful = await signInUser();
                    if (signInSuccessful != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(user: signInSuccessful),
                        ),
                      );
                    } else {
                      setState(() {
                        errorMessage = 'Invalid email or password';
                      });
                    }
                  }
                },
                child: Text('Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to sign in user by validating email and password
  Future<UserModel?> signInUser() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Hash the password using SHA256
    var hashedPassword = sha256.convert(utf8.encode(password)).toString();

    // Retrieve the user from Hive based on email asynchronously
    UserModel? user = await HiveService.getUserByEmail(email);

    // Validate if the user exists and the hashed password matches
    if (user != null && user.hashedPassword == hashedPassword) {
      return user;
    } else {
      return null;
    }
  }

}
