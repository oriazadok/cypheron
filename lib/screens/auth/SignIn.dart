import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication for user sign-in

import 'package:cypheron/services/HiveService.dart'; // Service for managing Hive-based local database
import 'package:cypheron/models/UserModel.dart'; // User model for handling user data structure

import 'package:cypheron/ui/screensUI/AuthUI.dart'; // UI wrapper for authentication screens
import 'package:cypheron/ui/widgetsUI/formUI/FormUI.dart'; // Form UI widget structure
import 'package:cypheron/ui/widgetsUI/utilsUI/FittedTextUI.dart'; // Custom widget for styled text
import 'package:cypheron/ui/widgetsUI/utilsUI/GenericTextStyleUI.dart'; // Generic text styles for consistency

import 'package:cypheron/widgets/form_elements/GenericFormField.dart'; // Input field widget for forms

import 'package:cypheron/screens/home/Home.dart'; // Home screen to navigate to after successful sign-in

/// The `SignIn` class represents the user sign-in screen.
/// This screen allows users to log in using their email and password.
class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

/// The state class for the `SignIn` screen
class _SignInState extends State<SignIn> {
  // Controllers for capturing and managing the text entered in email and password fields
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // Variable to store error messages, displayed to the user on invalid input
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthUI(
        // Wraps the form UI with a consistent structure for authentication screens
        form: FormUI(
          title: 'Sign In', // Title displayed at the top of the form

          // List of widgets to capture user input and display feedback
          inputFields: [
            // Email input field
            GenericFormField(
              fieldType: FieldType.email, // Specifies this field is for email input
              controller: _emailController, // Controller to manage email input
            ),

            // Password input field
            GenericFormField(
              fieldType: FieldType.password, // Specifies this field is for password input
              controller: _passwordController, // Controller to manage password input
            ),

            // Displays an error message if `errorMessage` is not empty
            if (errorMessage != '')
              FittedTextUI(text: errorMessage, type: TextType.err),
          ],

          // Callback executed when the "Sign In" button is pressed
          onClick: () async {
            String? uid = await _signInFB(); // Attempt to sign in the user
            if (uid != null) {
              // Validate the user's credentials in the local Hive database
              UserModel? signInSuccessful = await signInHive(uid);
              if (signInSuccessful != null) {
                // Navigate to the home screen if the sign-in is successful
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home(user: signInSuccessful)),
                  (route) => false, // Remove all previous routes from the navigation stack
                );
              } else {
                // Set an error message if the sign-in fails
                setState(() {
                  errorMessage = 'Invalid email or password';
                });
              }
            }
          },
          buttonText: 'Sign In', // Text displayed on the sign-in button
        ),
      ),
    );
  }

  /// Function to handle Firebase sign-in
  /// Returns the UID of the authenticated user if successful, or null if an error occurs
  Future<String?> _signInFB() async {
    String email = _emailController.text.trim(); // Get the email from the input field
    String password = _passwordController.text.trim(); // Get the password from the input field

    try {
      // Attempt to sign in the user using Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user!.uid; // Return the UID of the signed-in user

    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Authentication errors
      if (e.code == 'user-not-found') {
        setState(() {
          errorMessage = 'No user found for that email.'; // Email not registered
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          errorMessage = 'Incorrect password provided.'; // Password mismatch
        });
      } else if (e.code == 'invalid-credential') {
        setState(() {
          errorMessage = 'Invalid credentials. Please check your input.'; // Invalid email format
        });
      } else {
        setState(() {
          errorMessage = 'Unexpected error: ${e.message}'; // Other unexpected errors
        });
      }
      return null; // Return null if an error occurs
    } catch (e) {
      // Handle non-Firebase-specific errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')), // Display a generic error message
      );
      return null; // Return null for generic errors
    }
  }

  /// Function to validate the user's credentials against the local Hive database
  /// Returns a `UserModel` if the user is found and authenticated successfully, or null otherwise
  Future<UserModel?> signInHive(String? uid) async {
    // Retrieve the user from the Hive database using their UID
    UserModel? user = await HiveService.getUserByUid(uid);

    if (user != null) {
      return user; // Return the user if the credentials are valid
    } else {
      return null; // Return null if the user is not found or invalid
    }
  }
}
