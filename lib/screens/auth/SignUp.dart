import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase authentication

import 'package:cypheron/ui/screensUI/AuthUI.dart'; // Custom UI for authentication screens
import 'package:cypheron/ui/widgetsUI/formUI/FormUI.dart'; // Custom UI for form layouts
import 'package:cypheron/ui/widgetsUI/utilsUI/FittedTextUI.dart'; // Custom widget for styled text
import 'package:cypheron/ui/widgetsUI/utilsUI/GenericTextStyleUI.dart'; // Custom utility for text styles

import 'package:cypheron/widgets/form_elements/GenericFormField.dart'; // Generic input field widget
import 'package:cypheron/screens/home/Home.dart'; // Home screen to navigate after sign-up

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _emailController = TextEditingController(); // Controller for email input
  TextEditingController _passwordController = TextEditingController(); // Controller for password input

  String errorMessage = ''; // Variable to display error messages
  late TextType typeMessage; // Type of error message
  bool isLoading = false; // Tracks whether the app is performing a sign-up operation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( 
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ensure the column takes only the required space
          children: [
            // Main authentication UI
            AuthUI(
              form: FormUI(
                title: 'Sign Up',
                inputFields: [
                  GenericFormField(
                    fieldType: FieldType.email,
                    controller: _emailController,
                  ),
                  GenericFormField(
                    fieldType: FieldType.password,
                    controller: _passwordController,
                  ),
                  if (errorMessage != '')
                    FittedTextUI(
                      text: errorMessage,
                      type: typeMessage,
                    ),
                ],
                onClick: () async {
                  setState(() {
                    isLoading = true; // Show loading indicator
                  });

                  User? user = await _signUpFB();
                  if (user != null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(userCredential: user),
                      ),
                    );
                  } else {
                    setState(() {
                      isLoading = false; // Hide loading indicator
                    });
                  }
                },
                buttonText: 'Sign Up',
              ),
            ),

            // Loading indicator overlay
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.5), // Semi-transparent background
                child: Center(
                  child: CircularProgressIndicator(), // Circular loading spinner
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Firebase sign-up process
  Future<User?> _signUpFB() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      // Create a new user in Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data to Firestore
      User? user = userCredential.user;

      return user; // Return UID if successful
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          errorMessage = 'The password provided is too weak.\nPassword should be at least 6 characters.';
          typeMessage = TextType.warning;
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          errorMessage = 'The account already exists for that email.';
          typeMessage = TextType.err;
        });
      } else {
        setState(() {
          errorMessage = 'Error: ${e.message}';
          typeMessage = TextType.err;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
    return null; // Return null if an error occurs
  }

}