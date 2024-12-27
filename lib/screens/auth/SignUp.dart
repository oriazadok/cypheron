import 'package:flutter/material.dart';

import 'package:cypheron/services/FireBaseService.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase authentication

import 'package:cypheron/services/HiveService.dart';
import 'package:cypheron/models/UserModel.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthUI(
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

            showDialog(
              context: context,
              barrierDismissible: false, // Prevent closing the dialog while loading
              builder: (context) => Center(
                child: CircularProgressIndicator(), // Spinner
              ),
            );

            User? user;
            try {
              user = await _signUpFB();
            } finally {
              // Dismiss the dialog after the Firebase operation is complete
              Navigator.pop(context);
            }
            
            if (user != null) {
              // Try to sign up in hive 
              UserModel newUser = UserModel(
                userId: user.uid,
                email: user.email!,
                contactIds: [],
              );

              bool isAdded = await HiveService.addUser(newUser);
              if (isAdded) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(user: user!, userModel: newUser,),
                  ),
                );
              } 
            }
          },
          buttonText: 'Sign Up',
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
      User? user = await FireBaseService.signUp(email, password);

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