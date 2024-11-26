import 'package:flutter/material.dart';

/// Enum to represent different text styles
enum TextType { head_line, title, button, empty_state, contact_card, err, normal }

/// A factory class that creates different types of `TextFormField` based on the input type.
class GenericTextStyleUI {
  /// Returns a `TextFormField` based on the provided type string.
  static TextStyle getTextStyle( TextType type ) {
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
      
      case TextType.empty_state:
        return TextStyle(
          fontSize: 18,
          color: Colors.white70,
        );
      
      case TextType.contact_card:
        return const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
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
