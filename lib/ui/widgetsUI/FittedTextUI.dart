import 'package:flutter/material.dart';

/// A reusable widget for displaying text with a fitted box.
class FittedTextUI extends StatelessWidget {
  final String text;
  final String type;

  /// Constructor for the FittedText widget.
  FittedTextUI({
    required this.text,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 280), // Set a max width for the text.
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          style: buildTextStyle(type)
        ),
      ),
    );
  }

  TextStyle? buildTextStyle(String type) {

    if (type == "head") {
      return TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          );
    }

    if (type == "err") {
      return TextStyle(
            fontSize: 18,
            color: Colors.redAccent,
          );
    }

    return TextStyle();
  }
}
