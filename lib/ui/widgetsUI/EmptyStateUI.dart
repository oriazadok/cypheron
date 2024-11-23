import 'package:cypheron/ui/widgetsUI/IconsUI.dart';
import 'package:flutter/material.dart';

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
          Text(
            this.message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}


