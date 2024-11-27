import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart'; // For secure hashing of passwords
import 'dart:convert'; // For encoding data into UTF-8

import 'package:cypheron/services/HiveService.dart'; // Service for managing Hive database
import 'package:cypheron/models/UserModel.dart'; // Model class for user data

import 'package:cypheron/ui/screensUI/AuthUI.dart'; // UI structure for authentication screens
import 'package:cypheron/ui/widgetsUI/formUI/FormUI.dart'; // UI structure for forms

import 'package:cypheron/widgets/form_elements/GenericFormField.dart'; // Generic input form field widget
import 'package:cypheron/screens/home/Home.dart'; // Home screen to navigate to after sign-up

/// The `SignUp` class represents the user registration screen of the app.
/// It is a `StatefulWidget` because it needs to manage input fields and user state.
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

/// State class for the `SignUp` screen
class _SignUpState extends State<SignUp> {
  // Controllers for handling user input
  TextEditingController _nameController = TextEditingController(); // For the user's name
  TextEditingController _phoneController = TextEditingController(); // For the user's phone number
  TextEditingController _emailController = TextEditingController(); // For the user's email
  TextEditingController _passwordController = TextEditingController(); // For the user's password

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthUI(
        // Wraps the form UI with additional authentication styling
        form: FormUI(
          title: 'Sign Up', // Title of the form

          // List of input fields for the form
          inputFields: [
            // Input field for the user's name
            GenericFormField(
              fieldType: FieldType.name,
              controller: _nameController,
            ),
            // Input field for the user's phone number
            GenericFormField(
              fieldType: FieldType.phone,
              controller: _phoneController,
            ),
            // Input field for the user's email
            GenericFormField(
              fieldType: FieldType.email,
              controller: _emailController,
            ),
            
            // Password input field
            GenericFormField(
              fieldType: FieldType.password,
              controller: _passwordController,
            ),
          ],

          // Callback for the "Sign Up" button
          onClick: () async {
            UserModel? signUpSuccessful = await _handleSignUp(); // Handles user registration

            if (signUpSuccessful != null) {
              // If registration is successful, navigate to the Home screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(user: signUpSuccessful),
                ),
              );
            }
          },

          buttonText: 'Sign Up', // Text displayed on the button
        ),
      ),
    );
  }

  /// Handles the user sign-up process.
  /// - Hashes the password.
  /// - Creates a `UserModel` object with the provided input.
  /// - Adds the user to the Hive database.
  /// - Returns the `UserModel` if registration is successful, otherwise `null`.
  Future<UserModel?> _handleSignUp() async {
    // Hash the password securely using SHA-256
    var hashedPassword = sha256.convert(utf8.encode(_passwordController.text)).toString();

    // Create a new user model with the provided input
    UserModel newUser = UserModel(
      name: _nameController.text,
      phoneNumber: _phoneController.text,
      email: _emailController.text,
      hashedPassword: hashedPassword,
    );

    // Attempt to add the user to the database
    bool isAdded = await HiveService.addUser(newUser);

    if (isAdded) {
      // Fetch the user again from the database to verify
      UserModel? reloadUser = await HiveService.getUserByEmail(_emailController.text);

      if (reloadUser != null) {
        return reloadUser; // Return the user if found
      } else {
        print("Failed to fetch user."); // Debug message for failure
        return null;
      }
    } else {
      print("Failed to add user."); // Debug message for failure
      return null;
    }
  }
}
