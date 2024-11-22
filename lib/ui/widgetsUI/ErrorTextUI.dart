import 'package:flutter/material.dart';

/// A reusable widget for displaying a loading indicator with custom styling.
class ErrorTextUI extends StatelessWidget {
  final String text;

  const ErrorTextUI({
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
