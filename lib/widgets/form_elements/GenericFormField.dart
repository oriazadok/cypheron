import 'package:flutter/material.dart';

/// Enum representing different types of `TextFormField`.
enum FieldType {
  name,
  email,
  password,
  phone,
  title,
  textBox,
  text,
}

/// A class that manages the creation of different types of `TextFormField` widgets.
class GenericFormField extends StatelessWidget {
  final FieldType fieldType;
  final TextEditingController controller;
  final String labelText;

  /// Constructor to initialize the required parameters.
  const GenericFormField({
    Key? key,
    required this.fieldType,
    required this.controller,
    this.labelText = '',
  }) : super(key: key);

  /// Determines the appropriate `TextFormField` based on the `FieldType`.
  @override
  Widget build(BuildContext context) {
    switch (fieldType) {
      case FieldType.name:
        return _buildTextFormField(
          labelText: labelText.isEmpty ? 'Name' : labelText,
          keyboardType: TextInputType.name,
          validator: (value) => _validateNotEmpty(value, 'Please enter your name'),
        );
      case FieldType.email:
        return _buildTextFormField(
          labelText: labelText.isEmpty ? 'Email' : labelText,
          keyboardType: TextInputType.emailAddress,
          validator: (value) => _validateEmail(value),
        );
      case FieldType.password:
        return _buildTextFormField(
          labelText: labelText.isEmpty ? 'Password' : labelText,
          obscureText: true,
          validator: (value) => _validateNotEmpty(value, 'Please enter your password'),
        );
      case FieldType.phone:
        return _buildTextFormField(
          labelText: labelText.isEmpty ? 'Phone' : labelText,
          keyboardType: TextInputType.phone,
          validator: (value) => _validatePhone(value),
        );
      case FieldType.title:
        return _buildTextFormField(
          labelText: labelText.isEmpty ? 'Title' : labelText,
          validator: (value) => _validateNotEmpty(value, 'Please enter a message title'),
        );
      case FieldType.textBox:
        return _buildTextFormField(
          labelText: labelText.isEmpty ? 'Text to encrypt' : labelText,
          maxLines: 5,
          validator: (value) => _validateNotEmpty(value, 'This field cannot be empty'),
        );
      case FieldType.text:
      default:
        return _buildTextFormField(
          labelText: labelText.isEmpty ? 'Text' : labelText,
          keyboardType: TextInputType.text,
          validator: (value) => _validateNotEmpty(value, 'Please enter text'),
        );
    }
  }

  /// Helper method to create a `TextFormField` with common properties.
  Widget _buildTextFormField({
    required String labelText,
    TextInputType? keyboardType,
    bool obscureText = false,
    int? maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      validator: validator,
    );
  }

  /// Validates that a field is not empty.
  String? _validateNotEmpty(String? value, String errorMessage) {
    if (value == null || value.isEmpty) {
      return errorMessage;
    }
    return null;
  }

  /// Validates an email format.
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates a phone number format.
  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
}
