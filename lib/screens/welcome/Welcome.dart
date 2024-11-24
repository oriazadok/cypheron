import 'package:flutter/material.dart';

import 'package:cypheron/ui/screensUI/WelcomeUI.dart';

import 'package:cypheron/widgets/logo/LockLogo.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/FittedTextUI.dart';
import 'package:cypheron/ui/widgetsUI/buttonUI/NavigationButtonUI.dart';
import 'package:cypheron/screens/auth/SignIn.dart';
import 'package:cypheron/screens/auth/SignUp.dart';


/// Welcome screen with an improved dark-themed UI.
class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WelcomeUI(
      logo: LockLogo(),
      text: FittedTextUI(text: 'Welcome to Cypheron!', type: "head"),
      signIn: NavigationButtonUI(label: 'Sign In', destination: SignIn()),
      signUp: NavigationButtonUI(label: 'Sign Up', destination: SignUp()),
    );
  }
}
