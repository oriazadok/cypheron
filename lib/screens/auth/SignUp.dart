import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase authentication
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore database

import 'package:cypheron/services/HiveService.dart'; // Hive database service for local storage
import 'package:cypheron/models/UserModel.dart'; // User model for structuring user data

import 'package:cypheron/ui/screensUI/AuthUI.dart'; // Custom UI for authentication screens
import 'package:cypheron/ui/widgetsUI/formUI/FormUI.dart'; // Custom UI for form layouts
import 'package:cypheron/ui/widgetsUI/utilsUI/FittedTextUI.dart'; // Custom widget for styled text
import 'package:cypheron/ui/widgetsUI/utilsUI/GenericTextStyleUI.dart'; // Custom utility for text styles

import 'package:cypheron/widgets/form_elements/GenericFormField.dart'; // Generic input field widget

import 'package:cypheron/screens/home/Home.dart'; // Home screen to navigate after sign-up

/// The `SignUp` class represents the user registration screen of the app.
/// It is a `StatefulWidget` because it manages input fields and dynamic state.
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

/// The state class for the `SignUp` screen.
class _SignUpState extends State<SignUp> {
  // Controllers for handling user input
  TextEditingController _emailController = TextEditingController(); // Controller for email input
  TextEditingController _passwordController = TextEditingController(); // Controller for password input

  // Variable to display error messages on the UI
  String errorMessage = '';

  // Enum-like type to define the type of error message (e.g., warning or error)
  late TextType typeMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // UI for the authentication process
      body: AuthUI(
        form: FormUI(
          title: 'Sign Up', // Title displayed at the top of the form
          inputFields: [
            // Email input field
            GenericFormField(
              fieldType: FieldType.email,
              controller: _emailController,
            ),
            // Password input field
            GenericFormField(
              fieldType: FieldType.password,
              controller: _passwordController,
            ),
            // Display error message if there is one
            if (errorMessage != '')
              FittedTextUI(
                text: errorMessage,
                type: typeMessage,
              ),
          ],
          // Action triggered when the user presses the "Sign Up" button
          onClick: () async {
            String? uid = await _signUpFB(); // Perform sign-up via Firebase
            if (uid != null) {
              // If sign-up is successful, save data to Hive local storage
              UserModel? signUpSuccessful = await _signUpHive(uid);
              if (signUpSuccessful != null) {
                // Navigate to the Home screen with the signed-up user data
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(user: signUpSuccessful),
                  ),
                );
              }
            }
          },
          buttonText: 'Sign Up', // Text displayed on the submit button
        ),
      ),
    );
  }

  /// Function to handle Firebase sign-up and data storage
  Future<String?> _signUpFB() async {
    String email = _emailController.text.trim(); // Get trimmed email input
    String password = _passwordController.text.trim(); // Get trimmed password input

    try {
      // Create a new user in Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Extract the UID from the user credential
      String uid = userCredential.user!.uid;

      // Save the user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        "uid": uid,
        "email": email,
        "signUpDate": DateTime.now().toIso8601String(),
        "analyticsData": {"totalTimeSpent": 0}, // Initial analytics data
      });

      // Return the UID if sign-up is successful
      return uid;

    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific exceptions
      print(e); // Debugging
      if (e.code == 'weak-password') {
        // Display a specific message for weak passwords
        setState(() {
          errorMessage = 'The password provided is too weak.\nPassword should be at least 6 characters.';
          typeMessage = TextType.warning; // Indicate it's a warning
        });
      } else if (e.code == 'email-already-in-use') {
        // Display a specific message if the email is already used
        setState(() {
          errorMessage = 'The account already exists for that email.';
          typeMessage = TextType.err; // Indicate it's an error
        });
      } else {
        // General error message
        setState(() {
          errorMessage = 'Error: ${e.message}';
          typeMessage = TextType.err;
        });
      }
    } catch (e) {
      // Handle unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    // Return null if there was an error
    return null;
  }

  /// Function to save the user data locally in Hive
  Future<UserModel?> _signUpHive(String? uid) async {
    // Create a new UserModel instance
    UserModel newUser = UserModel(
      userId: uid!,
      email: _emailController.text,
    );

    // Add the new user to the Hive database
    bool isAdded = await HiveService.addUser(newUser);

    // Return the user model if successfully added
    if (isAdded) {
      return newUser;
    } else {
      // Return null if adding the user failed
      return null;
    }
  }
}
