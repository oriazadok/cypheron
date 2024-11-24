import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart'; // For hashing passwords securely
import 'dart:convert'; // For encoding strings to UTF-8

import 'package:cypheron/services/HiveService.dart'; // Service for managing Hive database
import 'package:cypheron/models/UserModel.dart'; // Model for user data

import 'package:cypheron/ui/screensUI/AuthUI.dart'; // UI structure for authentication screens
import 'package:cypheron/ui/widgetsUI/FormUI.dart'; // UI structure for forms
import 'package:cypheron/ui/widgetsUI/FittedTextUI.dart'; // Widget for displaying text with a specific style

import 'package:cypheron/widgets/form_elements/GenericFormField.dart'; // Generic form field for input

import 'package:cypheron/screens/home/Home.dart'; // Home screen for navigation after signing in

/// The `SignIn` class defines the sign-in screen of the app. 
/// It uses a stateful widget to manage user input and authentication.
class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // Controllers for managing input in email and password fields
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // String to display error messages to the user
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'), // Title of the screen displayed in the AppBar
      ),
      body: AuthUI(
        // Wraps the form UI with additional authentication styling and behavior
        form: FormUI(
          title: 'Sign In', // Title of the form displayed at the top

          // List of input fields and dynamic widgets
          inputFields: [
            // Email input field
            GenericFormField.getFormField(
              type: 'email',
              controller: _emailController,
            ),
            // Password input field
            GenericFormField.getFormField(
              type: 'password',
              controller: _passwordController,
            ),
            // Displays an error message if there's one
            if (errorMessage != '')
              FittedTextUI(text: errorMessage, type: "err"),
          ],

          // Function executed when the "Sign In" button is clicked
          onClick: () async {
            UserModel? signInSuccessful = await signInUser(); // Attempt to sign in the user
            if (signInSuccessful != null) {
              // Navigate to the Home screen and clear the navigation stack
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Home(user: signInSuccessful)),
                (route) => false,
              );
            } else {
              // Display an error message if sign-in fails
              setState(() {
                errorMessage = 'Invalid email or password';
              });
            }
          },
          buttonText: 'Sign In', // Text displayed on the button
        ),
      ),
    );
  }

  /// Attempts to sign in the user by validating their credentials.
  /// 
  /// Returns:
  /// - `UserModel` if the email and password match a user in the database.
  /// - `null` if the credentials are invalid.
  Future<UserModel?> signInUser() async {
    // Retrieve input values from the controllers
    String email = _emailController.text;
    String password = _passwordController.text;

    // Hash the password using SHA-256 for secure comparison
    var hashedPassword = sha256.convert(utf8.encode(password)).toString();

    // Fetch the user from the Hive database using their email
    UserModel? user = await HiveService.getUserByEmail(email);

    // Validate the hashed password
    if (user != null && user.hashedPassword == hashedPassword) {
      return user; // Return the user if the credentials are valid
    } else {
      return null; // Return null if the credentials are invalid
    }
  }
}
