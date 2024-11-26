import 'package:flutter/material.dart';
import 'package:cypheron/screens/auth/SignIn.dart';

enum IconType { 
  lock_logo,
  logout,
  refresh,
  mail,
  add,
  arrow,
  person,
  person_add,
  contacts,
  lock,
  contacts_outlined,
  send,
  copy,
  visibility,
  visibility_off,
  delete,
}

/// A reusable widget for creating custom icons and icon buttons.
class IconsUI extends StatelessWidget {
  final IconType type; // The type of icon or button to render
  final bool isButton; // Determines if the widget is an IconButton
  final BuildContext? context; // Required for navigation if isButton is true
  final Function(Object?)? onReturnData; // Optional callback for IconButton
  final VoidCallback? onPressed;

  const IconsUI({
    Key? key,
    required this.type,
    this.isButton = false,
    this.context,
    this.onReturnData,
    this.onPressed,
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
    switch (type) {
      case IconType.logout:
        return IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            Navigator.pushReplacement(
              context!,
              MaterialPageRoute(builder: (context) => SignIn()),
            );
          },
        );
      
      case IconType.refresh:
        return IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            if (this.onPressed != null) {
              this.onPressed!();
            }
          },
        );
      
      case IconType.send:
        return IconButton(
          icon: Icon(Icons.send),
          // color: Colors.deepPurpleAccent,
          onPressed: () {
            if (this.onPressed != null) {
              this.onPressed!();
            }
          },
        );

      case IconType.copy:
        return IconButton(
          icon: Icon(Icons.copy),
          // color: Colors.deepPurpleAccent,
          onPressed: () {
            if (this.onPressed != null) {
              this.onPressed!();
            }
          },
        );

      case IconType.visibility:
        return IconButton(
          icon: Icon(Icons.visibility),
          onPressed: () {
            if (this.onPressed != null) {
              this.onPressed!(); // Trigger the provided callback
            }
          },
        );

      case IconType.visibility_off:
        return IconButton(
          icon: Icon(Icons.visibility_off),
          onPressed: () {
            if (this.onPressed != null) {
              this.onPressed!(); // Trigger the provided callback
            }
          },
        );

      case IconType.delete:
        return IconButton(
          icon: Icon(Icons.delete_outline_outlined),
          onPressed: () {
            if (this.onPressed != null) {
              this.onPressed!(); // Trigger the provided callback
            }
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
    switch (type) {

      case IconType.lock_logo:
        return Icon(Icons.lock_outline, color: Colors.white, size: 100);

      case IconType.mail:
        return Icon(Icons.mail_outline,
            color: Colors.deepPurpleAccent, size: 80);

      case IconType.add:
        return Icon(Icons.add, color: Colors.white, size: 28);

      case IconType.person:
        return Icon(Icons.person, color: Colors.white);

      case IconType.person_add:
        return Icon(Icons.person_add_alt_1, color: Colors.deepPurpleAccent, size: 28);

      case IconType.contacts:
        return Icon(Icons.contacts, color: Colors.deepPurpleAccent, size: 28);

      case IconType.lock:
        return Icon(Icons.lock, color: Colors.deepPurpleAccent, size: 28);

      case IconType.contacts_outlined:
        return Icon(Icons.contacts_outlined,
            color: Colors.deepPurpleAccent, size: 80);

      case IconType.arrow:
        return Icon(Icons.arrow_forward_ios,
            color: Colors.grey, size: 16);
      
      case IconType.delete:
        return Icon(Icons.delete_outline_outlined);

      default:
        return Icon(Icons.whatshot);
    }
  }

  
}
