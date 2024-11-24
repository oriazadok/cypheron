import 'package:flutter/material.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/IconsUI.dart';

/// A reusable Hero widget for the app logo with a smooth animation effect.
class LockLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'app-logo',
      child: IconsUI(type: "lock-logo"),
    );
  }
}
