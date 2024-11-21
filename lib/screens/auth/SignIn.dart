import 'package:flutter/material.dart';

import 'package:crypto/crypto.dart';  // For hashing the password
import 'dart:convert';  // For UTF8 encoding

import 'package:cypheron/services/HiveService.dart';  // Hive service to handle data storage
import 'package:cypheron/models/UserModel.dart';  // UserModel for representing the user data

import 'package:cypheron/ui/screensUI/AuthUI.dart';
import 'package:cypheron/ui/widgetsUI/FormUI.dart';

import 'package:cypheron/widgets/form_elements/GenericTextFormField.dart';
import 'package:cypheron/widgets/states/ErrorMessage.dart';
import 'package:cypheron/screens/home/Home.dart';  // Home screen to navigate to on successful sign-in

/// SignIn screen for user authentication, allowing users to enter their credentials.
/// On successful sign-in, redirects to the Home screen.
class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  
  TextEditingController _emailController = TextEditingController();  // Controller for email input
  TextEditingController _passwordController = TextEditingController();  // Controller for password input
  String errorMessage = '';  // Stores error message to display in case of sign-in failure

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),  // Title of the SignIn screen
      ),
      body: AuthUI(
          form: FormUI(
            title: 'Sign In',
            
            // Input fields for the form
            inputFields: [
              GenericTextFormField.getTextFormField(
                type: 'email',
                controller: _emailController,
              ),
              GenericTextFormField.getTextFormField(
                type: 'password',
                controller: _passwordController,
              ),
              if (errorMessage != '')
                ErrorMessage(message: errorMessage),
            ],

            onClick: () async {

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
            },
            buttonText: 'Sign In',  // Button text
          ),
        )
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
