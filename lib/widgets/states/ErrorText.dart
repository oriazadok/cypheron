import 'package:flutter/material.dart';

/// A reusable widget for displaying a loading indicator with custom styling.
class ErrorText extends StatelessWidget {
  final String text;

  const ErrorText({
    required this.text, 
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        this.text,
        style: TextStyle(fontSize: 18, color: Colors.redAccent),
      ),
    );
  }
}
