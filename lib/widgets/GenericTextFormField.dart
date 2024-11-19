import 'package:flutter/material.dart';

/// A factory class that creates different types of `TextFormField` based on the input type.
class GenericTextFormField {
  /// Returns a `TextFormField` based on the provided type string.
  static Widget getTextFormField({
    required String type,
    required TextEditingController controller,
    String labelText = '',
  }) {
    switch (type.toLowerCase()) {

      case 'name':
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(labelText: labelText.isEmpty ? 'Name' : labelText),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        );
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

      case 'phone':
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(labelText: labelText.isEmpty ? 'Phone' : labelText),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a phone number';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        );
      
      case 'title':
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(labelText: labelText.isEmpty ? 'Title' : labelText),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a phone number';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        );

      case 'text-box':
        return TextField(
          controller: controller,
          decoration: InputDecoration(labelText: labelText.isEmpty ? 'Text to encrypt' : labelText),
          maxLines: 5,  // Allow multiple lines for longer text
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
