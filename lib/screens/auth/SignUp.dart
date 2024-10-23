import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart'; // For hashing the password
import 'dart:convert'; // For utf8 encoding

import 'package:cypheron/services/HiveService.dart'; // To store user data
import 'package:cypheron/models/UserModel.dart'; // The UserModel
import 'package:cypheron/screens/Home.dart'; // The UserModel


class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();  // Form key to validate the form

  // Controllers to handle input data
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // Function to handle sign-up logic
  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      // Hash the password
      var hashedPassword = sha256.convert(utf8.encode(_passwordController.text)).toString();

      // Create a new UserModel
      UserModel newUser = UserModel(
        name: _nameController.text,
        phoneNumber: _phoneController.text,
        email: _emailController.text,
        hashedPassword: hashedPassword,
      );

      // Store the user using Hive
      HiveService.addUser(newUser).then((isAdded) {
        if (isAdded) {
          // Redirect to Home page, passing userId
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(user: newUser),
            ),
          );
        } else {
          // Show an error message to the user
          print("Failed to add user.");
        }
      }).catchError((error) {
        print("Error saving user: $error");
      });

      // Clear the form after successful sign-up
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name input field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              
              // Phone number input field
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

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

              // Sign Up button
              ElevatedButton(
                onPressed: _handleSignUp,
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
