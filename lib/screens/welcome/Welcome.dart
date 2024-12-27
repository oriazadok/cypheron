import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart'; // Firebase authentication
import 'package:cypheron/services/FireBaseService.dart';

import 'package:cypheron/services/HiveService.dart';
import 'package:cypheron/models/UserModel.dart';

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
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignIn()),
          ),
        ),

        // Navigation button for the "Sign Up" screen.
        NavButtonUI(
          label: 'Sign Up', // Button label for Sign Up.
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignUp()),
          ),
        ),

        NavButtonUI(
          label: 'Sign In with Google', // Button label for Sign In with Google.
          onTap: () async {

            // Show the loading spinner
            showDialog(
              context: context,
              barrierDismissible: false, // Prevent closing the dialog while loading
              builder: (context) => Center(
                child: CircularProgressIndicator(), // Spinner
              ),
            );
            
            User? user = await FireBaseService.signInWithGoogle();
              
            if (user != null) {
                UserModel? userModel = await HiveService.getUserByUid(user.uid);
                if (userModel != null) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home(user: user, userModel: userModel)
                    ),
                    (route) => false,
                  );
                } else {
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
                          builder: (context) => Home(user: user, userModel: newUser,),
                        ),
                      );
                    } 
                }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Google Sign-In failed')),
              );
            }
          },
        ),

        // ElevatedButton.icon(
        //   icon: Image.asset(
        //     'assets/icons/google_icon.png', // Add a Google logo asset
        //     height: 24.0,
        //   ),
        //   label: const Text("Sign in with Google"),
        //   onPressed: () async {

        //   },
        // ),
      ],
    );
  }
}
