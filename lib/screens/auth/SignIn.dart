import 'package:cypheron/services/FireBaseService.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication for user sign-in
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
  bool isLoading = false; // Tracks whether the app is performing a sign-in operation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main authentication UI
          AuthUI(
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
                setState(() {
                  isLoading = true; // Show loading indicator
                });

                User? user = await _signInFB();
                if (user != null) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home(userCredential: user,)),
                    (route) => false,
                  );
                  
                } else {
                  setState(() {
                    errorMessage = 'Invalid email or password';
                    isLoading = false; // Hide loading indicator
                  });
                }
              },
              buttonText: 'Sign In',
            ),
          ),

          // Loading indicator
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5), // Semi-transparent background
              child: Center(
                child: CircularProgressIndicator(), // Loading spinner
              ),
            ),
        ],
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
          errorMessage = 'Invalid credentials. Please check your input.';
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
