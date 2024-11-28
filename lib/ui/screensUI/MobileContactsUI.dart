import 'package:flutter/material.dart';
import 'package:cypheron/ui/widgetsUI/loading/LoadingCircle.dart'; // Import the new LoadingIndicator

/// A wrapper for displaying content with consistent layout and background styling.
class MobileContactsUI extends StatelessWidget {
  final bool isFetching;
  final Widget child;

  const MobileContactsUI({
    required this.isFetching,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1C1C1E), Color(0xFF2C2C34)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: isFetching
      ? LoadingCircle()
      : child
    );
  }
}
