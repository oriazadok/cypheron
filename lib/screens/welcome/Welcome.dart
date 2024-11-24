import 'package:flutter/material.dart';

import 'package:cypheron/ui/screensUI/WelcomeUI.dart';  // Custom UI layout for the Welcome screen.

import 'package:cypheron/widgets/logo/LockLogo.dart';  // Widget displaying the Cypheron logo.
import 'package:cypheron/ui/widgetsUI/utilsUI/FittedTextUI.dart';  // Widget for styled, adaptive text.
import 'package:cypheron/ui/widgetsUI/buttonUI/NavigationButtonUI.dart';  // Widget for navigation buttons.
import 'package:cypheron/screens/auth/SignIn.dart';  // Screen for user sign-in.
import 'package:cypheron/screens/auth/SignUp.dart';  // Screen for user sign-up.

/// The Welcome screen for the Cypheron app.
/// Provides users with initial options to sign in or sign up.
class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WelcomeUI(
      // Displays the app's logo prominently at the top of the screen.
      logo: LockLogo(),

      // Displays a welcome message with styled text.
      text: FittedTextUI(
        text: 'Welcome to Cypheron!', // Main welcome message.
        type: "head", // Text type for consistent styling.
      ),

      // Navigation button for the "Sign In" screen.
      signIn: NavigationButtonUI(
        label: 'Sign In', // Button text.
        destination: SignIn(), // Navigates to the SignIn screen.
      ),

      // Navigation button for the "Sign Up" screen.
      signUp: NavigationButtonUI(
        label: 'Sign Up', // Button text.
        destination: SignUp(), // Navigates to the SignUp screen.
      ),
    );
  }
}
