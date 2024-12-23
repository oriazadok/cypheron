import 'package:flutter/material.dart';

/// Enum to represent different text styles
enum TextType { head_line, title, button, empty_state, dialog_title, dialog_option, contact_card, sub_title_contact_card, msg_title, time, warning, err, normal }

/// A factory class that creates different types of `TextFormField` based on the input type.
class GenericTextStyleUI {
  /// Returns a `TextFormField` based on the provided type string.
  static TextStyle getTextStyle( TextType? type ) {
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
      
      case TextType.dialog_title:
        return const TextStyle(
          color: Colors.deepPurpleAccent,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        );
      
      case TextType.dialog_option:
        return TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.1,
        );
      
      case TextType.contact_card:
        return const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        );

      case TextType.sub_title_contact_card:
        return TextStyle(
          color: Colors.grey[300],
          fontSize: 16,
        );

      case TextType.msg_title:
        return TextStyle(
          fontWeight: FontWeight.bold
        );
      
      case TextType.normal:
        return TextStyle(
          color: Colors.grey
        );

      case TextType.time:
        return TextStyle(
            color: Colors.redAccent,
          );
      case TextType.warning:
        return TextStyle(
            fontSize: 18,
            color: Colors.amber,
          );

      case TextType.err:
        return TextStyle(
            fontSize: 18,
            color: Colors.redAccent,
          );
      
      default:
        return TextStyle(color: Colors.grey);
    }
  }
}
