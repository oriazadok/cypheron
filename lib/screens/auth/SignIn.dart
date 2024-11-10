import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';  // For hashing the password
import 'dart:convert';  // For UTF8 encoding
import 'package:cypheron/services/HiveService.dart';  // Hive service to handle data storage
import 'package:cypheron/models/UserModel.dart';  // UserModel for representing the user data
import 'package:cypheron/screens/Home.dart';  // Home screen to navigate to on successful sign-in

/// SignIn screen for user authentication, allowing users to enter their credentials.
/// On successful sign-in, redirects to the Home screen.
class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();  // Key to validate the sign-in form
  TextEditingController _emailController = TextEditingController();  // Controller for email input
  TextEditingController _passwordController = TextEditingController();  // Controller for password input
  String errorMessage = '';  // Stores error message to display in case of sign-in failure

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),  // Title of the SignIn screen
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),  // Add padding around the form
            child: Form(
              key: _formKey,  // Attach form key to enable validation
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  // Heading text for Sign In
                  Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  SizedBox(height: 30),  // Add spacing after heading
                  // Email input field with validation
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,  // Set input type to email
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';  // Error if email is empty
                      }
                      return null;  // Valid input
                    },
                  ),
                  SizedBox(height: 20),  // Add spacing

                  // Password input field with validation
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,  // Hide input text for privacy
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';  // Error if password is empty
                      }
                      return null;  // Valid input
                    },
                  ),
                  SizedBox(height: 20),  // Add spacing

                  // Display error message if any, in red color
                  if (errorMessage.isNotEmpty)
                    Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  SizedBox(height: 20),  // Add spacing

                  // Sign In button to trigger the sign-in process
                  ElevatedButton(
                    onPressed: () async {
                      // Validate the form fields
                      if (_formKey.currentState!.validate()) {
                        UserModel? signInSuccessful = await signInUser();  // Call sign-in logic
                        if (signInSuccessful != null) {
                          // If sign-in succeeds, navigate to Home screen with user data
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(user: signInSuccessful),
                            ),
                          );
                        } else {
                          // Set an error message if sign-in fails
                          setState(() {
                            errorMessage = 'Invalid email or password';
                          });
                        }
                      }
                    },
                    child: Text('Sign In'),  // Button text
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Attempts to authenticate the user by validating their email and password.
  /// Returns a UserModel if the sign-in is successful, otherwise returns null.
  Future<UserModel?> signInUser() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Hash the password using SHA256 for secure comparison
    var hashedPassword = sha256.convert(utf8.encode(password)).toString();

    // Retrieve the user from Hive storage based on email
    UserModel? user = await HiveService.getUserByEmail(email);

    // Check if user exists and if the hashed password matches
    if (user != null && user.hashedPassword == hashedPassword) {
      return user;  // Sign-in success
    } else {
      return null;  // Sign-in failure
    }
  }
}
