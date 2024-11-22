import 'package:flutter/material.dart';

/// A reusable widget for menu options with consistent styling.
class MenuOption extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const MenuOption({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurpleAccent, size: 28),
      title: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.1,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      tileColor: Color(0xFF2C2C34),
      onTap: onTap,
    );
  }
}
