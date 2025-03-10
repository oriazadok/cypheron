import 'package:flutter/material.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/IconsUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/GenericTextStyleUI.dart'; // Widget for displaying text with a specific style


/// A reusable widget for menu options with consistent styling.
class MenuOptionUI extends StatelessWidget {
  final IconsUI icon;
  final String text;
  final VoidCallback onTap;

  const MenuOptionUI({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(
        text,
        style: GenericTextStyleUI.getTextStyle(TextType.dialog_option),
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
