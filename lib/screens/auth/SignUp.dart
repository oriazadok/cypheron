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
      body: Stack(
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

                String? uid = await _signUpFB();
                if (uid != null) {
                  UserModel? signUpSuccessful = await _signUpHive(uid);
                  if (signUpSuccessful != null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(user: signUpSuccessful),
                      ),
                    );
                  } else {
                    setState(() {
                      errorMessage = 'Failed to save user locally.';
                      typeMessage = TextType.err;
                      isLoading = false; // Hide loading indicator
                    });
                  }
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
    );
  }

  /// Firebase sign-up process
  Future<String?> _signUpFB() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      // Create a new user in Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data to Firestore
      String uid = userCredential.user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        "uid": uid,
        "email": email,
        "signUpDate": DateTime.now().toIso8601String(),
        "analyticsData": {"totalTimeSpent": 0},
      });

      return uid; // Return UID if successful
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          errorMessage =
              'The password provided is too weak.\nPassword should be at least 6 characters.';
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

  /// Save user data locally in Hive
  Future<UserModel?> _signUpHive(String? uid) async {
    UserModel newUser = UserModel(
      userId: uid!,
      email: _emailController.text,
    );

    bool isAdded = await HiveService.addUser(newUser);
    if (isAdded) {
      return newUser;
    } else {
      return null;
    }
  }
}
