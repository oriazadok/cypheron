import 'package:flutter/material.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/GenericTextStyleUI.dart';

/// A reusable widget for displaying text with a fitted box.
class FittedTextUI extends StatelessWidget {
  final String text;
  final TextType type;

  /// Constructor for the FittedText widget.
  FittedTextUI({
    required this.text,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 280), // Set a max width for the text.
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          style: GenericTextStyleUI.getTextStyle(type),
        ),
      ),
    );
  }
}