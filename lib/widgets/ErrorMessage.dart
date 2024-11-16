import 'package:flutter/material.dart';

/// A reusable widget to display error messages.
class ErrorMessage extends StatelessWidget {
  final String message;

  /// Constructor for `ErrorMessage`.
  ErrorMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    // If the message is empty, return an empty container to avoid rendering an empty widget.
    if (message.isEmpty) {
      return SizedBox.shrink();
    }

    return Text(
      message,
      style: TextStyle(
        color: Colors.red,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
