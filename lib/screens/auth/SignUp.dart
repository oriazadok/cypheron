import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart'; // For hashing the password
import 'dart:convert'; // For utf8 encoding

import 'package:cypheron/services/HiveService.dart'; // To store user data
import 'package:cypheron/models/UserModel.dart'; // The UserModel
import 'package:cypheron/screens/Home.dart'; // The Home screen to navigate to after signup

/// SignUp screen allows new users to register by providing their information.
/// On successful registration, the user is redirected to the Home screen.
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();  // Form key to validate the form

  // Controllers to handle user input for name, phone, email, and password
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),  // Screen title
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,  // Attach form key to validate form fields
              child: Column(
                children: [

                  // Heading text for Sign In
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  SizedBox(height: 30),  // Add spacing after heading


                  // Name input field with validation
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
                  SizedBox(height: 20),  // Spacer

                  // Phone number input field with validation
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
                  SizedBox(height: 20),  // Spacer

                  // Email input field with validation
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
                  SizedBox(height: 20),  // Spacer

                  // Password input field with validation
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
                  SizedBox(height: 20),  // Spacer

                  // Sign Up button to trigger signup process
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Calls the signup function and checks if it returns a valid user
                        UserModel? signUpSuccessful = await _handleSignUp();

                        if (signUpSuccessful != null) {
                          // If signup is successful, navigate to Home screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(user: signUpSuccessful),
                            ),
                          );
                        } 
                      }
                    },
                    child: Text('Sign Up'),  // Button text
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Handles signup logic by creating a new user, storing it in Hive, 
  /// and reloading the user from the database to ensure data consistency.
  Future<UserModel?> _handleSignUp() async {
    // Hash the password using SHA256 for security
    var hashedPassword = sha256.convert(utf8.encode(_passwordController.text)).toString();

    // Create a new UserModel instance with the provided details
    UserModel newUser = UserModel(
      name: _nameController.text,
      phoneNumber: _phoneController.text,
      email: _emailController.text,
      hashedPassword: hashedPassword,
    );

    // Attempt to store the new user in Hive
    bool isAdded = await HiveService.addUser(newUser);

    if (isAdded) {
      // Reload the user from Hive to verify it was saved correctly
      UserModel? reloadUser = await HiveService.getUserByEmail(_emailController.text);

      // Return the reloaded user if successful, else print an error and return null
      if (reloadUser != null) {
        return reloadUser;
      } else {
        print("Failed to fetch user.");
        return null;
      }
    } else {
      print("Failed to add user.");
      return null;
    }
  }
}
