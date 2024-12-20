import 'package:flutter/material.dart';

enum IconType { 
  lock_logo,
  logout,
  refresh,
  mail,
  arrow,
  person,
  person_add,
  person_add_alt_1_outlined,
  contacts,
  lock,
  contacts_outlined,
  send,
  share,
  copy,
  visibility,
  visibility_off,
  add,
  delete,
  search,
}

/// A reusable widget for creating custom icons and icon buttons.
class IconsUI extends StatelessWidget {
  final IconType type; // The type of icon or button to render
  final VoidCallback? onPressed;

  const IconsUI({
    Key? key,
    required this.type,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Icon new_icon = _buildIcon();

    if(this.onPressed != null) {
      return IconButton(
        icon: new_icon,
        onPressed: () {
          if (this.onPressed != null) {
              this.onPressed!();
            }
        },
      );
    }

    return new_icon;
  }

  /// Builds an Icon based on the type.
  Icon _buildIcon() {
    switch (type) {

      case IconType.lock_logo:
        return Icon(Icons.lock_outline, color: Colors.white, size: 100);

      case IconType.logout:
        return Icon(Icons.logout);

      case IconType.contacts_outlined:
        return Icon(Icons.contacts_outlined, color: Colors.deepPurpleAccent, size: 80);

      case IconType.person_add_alt_1_outlined:
        return Icon(Icons.person_add_alt_1_outlined, color: Colors.white, size: 28);
        
      case IconType.person_add:
        return Icon(Icons.person_add_alt_1, color: Colors.deepPurpleAccent, size: 28);

      case IconType.contacts:
        return Icon(Icons.contacts, color: Colors.deepPurpleAccent, size: 28);

      case IconType.refresh:
        return Icon(Icons.refresh);

      case IconType.person:
        return Icon(Icons.person, color: Colors.white);

      case IconType.arrow:
        return Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16);

      case IconType.mail:
        return Icon(Icons.mail_outline,
            color: Colors.deepPurpleAccent, size: 80);

      case IconType.visibility:
        return Icon(Icons.visibility);

      case IconType.visibility_off:
        return Icon(Icons.visibility_off);

      case IconType.copy:
        return Icon(Icons.copy, color: Colors.deepPurpleAccent);

      case IconType.lock:
        return Icon(Icons.lock, color: Colors.deepPurpleAccent, size: 28);

      case IconType.send:
        return Icon(Icons.send);
      
      case IconType.share:
        return Icon(Icons.share);
      
      case IconType.delete:
        return Icon(Icons.delete_outline_outlined);

      case IconType.search:
        return Icon(Icons.search);

      case IconType.add:
        return Icon(Icons.add);

      default:
        return Icon(Icons.whatshot);
    }
  }
}
