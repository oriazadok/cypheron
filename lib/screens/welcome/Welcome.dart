import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase authentication

import 'package:cypheron/ui/screensUI/WelcomeUI.dart'; // Custom UI for the Welcome screen layout.

import 'package:cypheron/ui/widgetsUI/utilsUI/IconsUI.dart'; // Utility widget for displaying icons.
import 'package:cypheron/ui/widgetsUI/utilsUI/GenericTextStyleUI.dart'; // Provides generic text styles.
import 'package:cypheron/ui/widgetsUI/utilsUI/FittedTextUI.dart'; // Widget for dynamically styled text.
import 'package:cypheron/ui/widgetsUI/buttonUI/NavButtonUI.dart'; // Widget for creating navigation buttons.

import 'package:cypheron/screens/auth/SignIn.dart'; // Screen for user sign-in functionality.
import 'package:cypheron/screens/auth/SignUp.dart'; // Screen for user sign-up functionality.
import 'package:cypheron/screens/home/Home.dart'; // Home screen to navigate after sign-up

/// Represents the Welcome screen of the Cypheron app.
/// Provides navigation options for Sign In and Sign Up.
class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WelcomeUI(

      children: [
        // Displays the app's logo at the top of the Welcome screen.
        IconsUI(type: IconType.lock_logo),

        // Styled welcome message for users.
        FittedTextUI(
          text: 'Welcome to Cypheron!', // Main welcome text.
          type: TextType.head_line, // Consistent text styling across the app.
        ),

        // Navigation button for the "Sign In" screen.
        NavButtonUI(
          label: 'Sign In', // Button label for Sign In.
          destination: SignIn(), // Navigates to the SignIn screen.
        ),

        // Navigation button for the "Sign Up" screen.
        NavButtonUI(
          label: 'Sign Up', // Button label for Sign Up.
          destination: SignUp(), // Navigates to the SignUp screen.
        ),

        ElevatedButton.icon(
          icon: Image.asset(
            'assets/icons/google_icon.png', // Add a Google logo asset
            height: 24.0,
          ),
          label: const Text("Sign in with Google"),
          onPressed: () async {
            User? user = await _signInWithGoogle();
              
            if (user != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(userCredential: user),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Google Sign-In failed')),
              );
            }
          },
        ),
      ],
      
    );
  }

  // Google Sign-In
  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // Case when the user cancels the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      return user;
    } catch (e) {
      // Catch and log any errors during the process
      print("Error during Google Sign-In: $e");
      return null;
    }
  }
}
