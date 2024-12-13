import 'package:flutter/material.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/IconsUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/GenericTextStyleUI.dart';


/// A reusable widget for displaying contact cards with a consistent style.
class ContactCardUI extends StatelessWidget {
  final Widget leading;
  final String title;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  /// Constructor for the ContactCard widget.
  const ContactCardUI({
    Key? key,
    required this.leading,
    required this.title,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1C1C1C),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          leading: leading,
          title: Text(
            title,
            style: GenericTextStyleUI.getTextStyle(TextType.contact_card),
          ),
          trailing: IconsUI(type: IconType.arrow),
          onTap: onTap,
          onLongPress: onLongPress,
        ),
      ),
    );
  }
}
