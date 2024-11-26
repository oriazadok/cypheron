import 'package:flutter/material.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/IconsUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/FittedTextUI.dart'; // Widget for displaying text with a specific style


class EmptyStateUI extends StatelessWidget {

  final IconsUI icon;
  final String message;

  const EmptyStateUI({
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          this.icon,
          SizedBox(height: 20),
          FittedTextUI(
            text: this.message,
            type: TextType.empty_state,
          ),
        ],
      ),
    );
  }
}


