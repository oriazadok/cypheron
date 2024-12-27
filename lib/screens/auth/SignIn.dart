import 'package:flutter/material.dart';

import 'package:cypheron/services/FireBaseService.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication for user sign-in

import 'package:cypheron/services/HiveService.dart';
import 'package:cypheron/models/UserModel.dart';

import 'package:cypheron/ui/screensUI/AuthUI.dart'; // UI wrapper for authentication screens
import 'package:cypheron/ui/widgetsUI/formUI/FormUI.dart'; // Form UI widget structure
import 'package:cypheron/ui/widgetsUI/utilsUI/FittedTextUI.dart'; // Custom widget for styled text
import 'package:cypheron/ui/widgetsUI/utilsUI/GenericTextStyleUI.dart'; // Generic text styles for consistency

import 'package:cypheron/widgets/form_elements/GenericFormField.dart'; // Input field widget for forms

import 'package:cypheron/screens/home/Home.dart'; // Home screen to navigate to after successful sign-in

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // Controllers for capturing and managing the text entered in email and password fields
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String errorMessage = ''; // Variable to store error messages

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthUI(
        form: FormUI(
          title: 'Sign In',
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
              FittedTextUI(text: errorMessage, type: TextType.err),
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
              user = await _signInFB();
            } finally {
              // Dismiss the dialog after the Firebase operation is complete
              Navigator.pop(context);
            }

            if (user != null) {
              UserModel? userModel = await HiveService.getUserByUid(user.uid);
                if (userModel != null) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home(user: user!, userModel: userModel)
                    ),
                    (route) => false,
                  );
                } 
            }
          },
          buttonText: 'Sign In',
        ),
      ),
    );
  }

  Future<User?> _signInFB() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      User? user = await FireBaseService.signIn(email, password);

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          errorMessage = 'No user found for that email.';
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          errorMessage = 'Incorrect password provided.';
        });
      } else if (e.code == 'invalid-credential') {
        setState(() {
          errorMessage = 'Incorrect email or password';
        });
      } else {
        setState(() {
          errorMessage = 'Unexpected error: ${e.message}';
        });
      }
      return null;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      return null;
    }
  }

}
