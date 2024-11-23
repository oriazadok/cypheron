import 'package:flutter/material.dart';
import 'package:cypheron/screens/auth/SignIn.dart';

/// A reusable widget for creating custom icons and icon buttons.
class IconsUI extends StatelessWidget {
  final String type; // The type of icon or button to render
  final bool isButton; // Determines if the widget is an IconButton
  final BuildContext? context; // Required for navigation if isButton is true
  final Function(Object?)? onReturnData; // Optional callback for IconButton

  const IconsUI({
    Key? key,
    required this.type,
    this.isButton = false,
    this.context,
    this.onReturnData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If it's an IconButton, ensure a context is provided
    if (isButton && this.context == null) {
      throw FlutterError(
          "A BuildContext is required to create an IconButton.");
    }

    // Return an IconButton or an Icon based on isButton
    if (isButton) {
      return _buildIconButton();
    } else {
      return _buildIcon();
    }
  }

  /// Builds an IconButton based on the type.
  IconButton _buildIconButton() {
    switch (type.toLowerCase()) {
      case 'logout':
        return IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            Navigator.pushReplacement(
              context!,
              MaterialPageRoute(builder: (context) => SignIn()),
            );
          },
        );

      default:
        return IconButton(
          icon: Icon(Icons.help_outline),
          onPressed: () {
            ScaffoldMessenger.of(context!).showSnackBar(
              SnackBar(content: Text("Unknown action for type: $type")),
            );
          },
        );
    }
  }

  /// Builds an Icon based on the type.
  Icon _buildIcon() {
    switch (type.toLowerCase()) {
      case 'add':
        return Icon(Icons.add, color: Colors.deepPurpleAccent, size: 28);

      case 'person':
        return Icon(Icons.person, color: Colors.white);

      case 'lock':
        return Icon(Icons.lock, color: Colors.deepPurpleAccent, size: 28);

      case 'contacts_outlined':
        return Icon(Icons.contacts_outlined,
            color: Colors.deepPurpleAccent, size: 80);

      case 'mail':
        return Icon(Icons.mail_outline,
            color: Colors.deepPurpleAccent, size: 80);

      default:
        return Icon(Icons.logout);
    }
  }

  
}
