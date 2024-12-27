import 'package:flutter/material.dart';

import 'package:cypheron/ui/generalUI/GradientBackgroundUI.dart';

/// Welcome screen with an improved dark-themed UI.
class WelcomeUI extends StatelessWidget {

  final List<Widget> children;

  WelcomeUI({ required this.children });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Dark gradient background with a sleek design.
      body: GradientBackgroundUI(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  children[0],
                  SizedBox(height: 30),

                  children[1],
                  SizedBox(height: 40),

                  children[2],
                  SizedBox(height: 20),

                  children[3],
                  SizedBox(height: 40),

                  children[4],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
