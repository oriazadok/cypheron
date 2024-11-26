import 'package:flutter/material.dart';

/// Enum to represent different text styles
enum TextType { head_line, title, button, err, normal }

/// A reusable widget for displaying text with a fitted box.
class FittedTextUI extends StatelessWidget {
  final String text;
  final TextType type;

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

  TextStyle? buildTextStyle(TextType type) {
    switch (type) {
      case TextType.head_line:
        return TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            );
      
      case TextType.button:
        return TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.purple[300], // Lighter text color for better contrast
          letterSpacing: 1.2,
        );
      
      case TextType.title:
        return TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurpleAccent,
        );

      case TextType.err:
        return TextStyle(
            fontSize: 18,
            color: Colors.redAccent,
          );
      
      default:
        return TextStyle();
    }
  }
}
