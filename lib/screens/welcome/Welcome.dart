import 'package:flutter/material.dart';

import 'package:cypheron/ui/screensUI/WelcomeUI.dart'; // Custom UI for the Welcome screen layout.

import 'package:cypheron/ui/widgetsUI/utilsUI/IconsUI.dart'; // Utility widget for displaying icons.
import 'package:cypheron/ui/widgetsUI/utilsUI/GenericTextStyleUI.dart'; // Provides generic text styles.
import 'package:cypheron/ui/widgetsUI/utilsUI/FittedTextUI.dart'; // Widget for dynamically styled text.
import 'package:cypheron/ui/widgetsUI/buttonUI/NavButtonUI.dart'; // Widget for creating navigation buttons.

import 'package:cypheron/screens/auth/SignIn.dart'; // Screen for user sign-in functionality.
import 'package:cypheron/screens/auth/SignUp.dart'; // Screen for user sign-up functionality.

/// Represents the Welcome screen of the Cypheron app.
/// Provides navigation options for Sign In and Sign Up.
class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WelcomeUI(
      // Displays the app's logo at the top of the Welcome screen.
      logo: IconsUI(type: IconType.lock_logo),

      // Styled welcome message for users.
      text: FittedTextUI(
        text: 'Welcome to Cypheron!', // Main welcome text.
        type: TextType.head_line, // Consistent text styling across the app.
      ),

      // Navigation button for the "Sign In" screen.
      signIn: NavButtonUI(
        label: 'Sign In', // Button label for Sign In.
        destination: SignIn(), // Navigates to the SignIn screen.
      ),

      // Navigation button for the "Sign Up" screen.
      signUp: NavButtonUI(
        label: 'Sign Up', // Button label for Sign Up.
        destination: SignUp(), // Navigates to the SignUp screen.
      ),
    );
  }
}
