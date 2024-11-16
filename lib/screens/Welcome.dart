import 'package:flutter/material.dart';

import 'package:cypheron/ui/screensUI/WelcomeUI.dart';

import 'package:cypheron/widgets/LockLogo.dart';
import 'package:cypheron/widgets/FittedText.dart';
import 'package:cypheron/widgets/buttons/NavigationButton.dart';
import 'package:cypheron/screens/auth/SignIn.dart';
import 'package:cypheron/screens/auth/SignUp.dart';


/// Welcome screen with an improved dark-themed UI.
class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WelcomeUI(
      logo: LockLogo(),
      text: FittedText(text: 'Welcome to Cypheron!'),
      signIn: NavigationButton(label: 'Sign In', destination: SignIn()),
      signUp: NavigationButton(label: 'Sign Up', destination: SignUp()),
    );
  }
}
