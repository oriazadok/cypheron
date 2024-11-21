import 'package:flutter/material.dart';

/// A reusable Hero widget for the app logo with a smooth animation effect.
class LockLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'app-logo',
      child: Icon(
        Icons.lock_outline,
        size: 100,
        color: Colors.white,
      ),
    );
  }
}
