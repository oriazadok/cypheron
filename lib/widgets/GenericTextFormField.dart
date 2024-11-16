import 'package:flutter/material.dart';

/// A factory class that creates different types of `TextFormField` based on the input type.
class GenericTextFormField {
  /// Returns a `TextFormField` based on the provided type string.
  static TextFormField getTextFormField({
    required String type,
    required TextEditingController controller,
    String labelText = '',
  }) {
    switch (type.toLowerCase()) {
      case 'email':
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(labelText: labelText.isEmpty ? 'Email' : labelText),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            return null;
          },
        );

      case 'password':
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(labelText: labelText.isEmpty ? 'Password' : labelText),
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          },
        );

      case 'number':
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(labelText: labelText.isEmpty ? 'Number' : labelText),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a number';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        );

      case 'text':
      default:
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(labelText: labelText.isEmpty ? 'Text' : labelText),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter text';
            }
            return null;
          },
        );
    }
  }
}
