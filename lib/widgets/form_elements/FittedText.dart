import 'package:flutter/material.dart';

/// A reusable widget for displaying text with a fitted box.
class FittedText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final double letterSpacing;

  /// Constructor for the FittedText widget.
  FittedText({
    required this.text,
    this.fontSize = 28,
    this.fontWeight = FontWeight.bold,
    this.color = Colors.white,
    this.letterSpacing = 1.2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 280), // Set a max width for the text.
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
            letterSpacing: letterSpacing,
          ),
        ),
      ),
    );
  }
}
