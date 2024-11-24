import 'package:flutter/material.dart';

/// A factory class that creates different types of `TextFormField` based on the input type.
class GenericFormField {
  /// Returns a `TextFormField` based on the provided type string.
  static Widget getFormField({
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
            // Check if the field is empty
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            // Regex for validating email format
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            return null; // No error
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
            // Check if the field is empty
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            // Regex for validating phone number format
            final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$'); // Allow optional "+" and 10-15 digits
            if (!phoneRegex.hasMatch(value)) {
              return 'Please enter a valid phone number';
            }
            return null; // No error
          },
        );
      
      case 'title':
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(labelText: labelText.isEmpty ? 'Title' : labelText),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a message title';
            }
            return null;
          },
        );

      case 'text-box':
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(labelText: labelText.isEmpty ? 'Text to encrypt' : labelText),
          maxLines: 5,  // Allow multiple lines for longer text
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field cannot be empty'; // Error message when validation fails
            }
            return null; // No error
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
