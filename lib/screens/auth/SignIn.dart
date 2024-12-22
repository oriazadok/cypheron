import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart'; // Firestore

import 'package:cypheron/services/HiveService.dart'; // Service for managing Hive database
import 'package:cypheron/models/UserModel.dart'; // Model for user data

import 'package:cypheron/ui/screensUI/AuthUI.dart'; // UI structure for authentication screens
import 'package:cypheron/ui/widgetsUI/formUI/FormUI.dart'; // UI structure for forms
import 'package:cypheron/ui/widgetsUI/utilsUI/FittedTextUI.dart'; // Widget for displaying text with a specific style
import 'package:cypheron/ui/widgetsUI/utilsUI/GenericTextStyleUI.dart';

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
      body: AuthUI(
        // Wraps the form UI with additional authentication styling and behavior
        form: FormUI(
          title: 'Sign In', // Title of the form

          // List of input fields and dynamic widgets
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
            // Displays an error message if there's one
            if (errorMessage != '')
              FittedTextUI(text: errorMessage, type: TextType.err),
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

    UserCredential? userCredential = await _signInWithEmailAndPassword();

    if (userCredential != null) {
      print('Signed in as: ${userCredential.user?.email}');

      UserModel? user = await HiveService.getUserByUid(userCredential.user?.uid);

      // Validate the hashed password
      if (user != null) {
        return user; // Return the user if the credentials are valid
      } else {
        return null; // Return null if the credentials are invalid
      }
     
    } else {
      print('Sign-in failed');
    }

  return null;
    
  }

  Future<UserCredential?> _signInWithEmailAndPassword() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      // Sign in the user and return the UserCredential
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential; // Return the UserCredential object

    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password provided.';
      } else {
        errorMessage = 'Error: ${e.message}';
      }

      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      return null; // Return null in case of an error
    } catch (e) {
      // Handle other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      return null; // Return null in case of an error
    }
  }

}
