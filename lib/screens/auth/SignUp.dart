import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firestore
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore

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

    String? uid = await _signUpAndSaveUserData();
    if (uid != null) {

      // Create a new user model with the provided input
      UserModel newUser = UserModel(
        userId: uid,
        email: _emailController.text,
      );

      // Attempt to add the user to the database
      bool isAdded = await HiveService.addUser(newUser);

      if (isAdded) {
        // Fetch the user again from the database to verify
        UserModel? reloadUser = await HiveService.getUserByUid(uid);

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

    return null;
  }

  Future<String?> _signUpAndSaveUserData() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      // Create a new user in Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the UID of the created user
      String uid = userCredential.user!.uid;

      // Save user data in Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        "uid": uid,
        "email": email,
        "signUpDate": DateTime.now().toIso8601String(),
        "analyticsData": {"totalTimeSpent": 0},
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-Up Successful!')),
      );

      // Return the UID
      return uid;

    } on FirebaseAuthException catch (e) {
      // Handle errors during sign-up
      String errorMessage;
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else {
        errorMessage = 'Error: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      // Handle other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    // Return null if an error occurred
    return null;
  }


}
