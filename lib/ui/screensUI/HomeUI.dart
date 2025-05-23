import 'package:flutter/material.dart';
import 'package:cypheron/ui/generalUI/GradientBackgroundUI.dart';

/// Home screen that displays user's contacts and enables decryption of shared files.
class HomeUI extends StatefulWidget {

  final bool isSaving;
  final List<Widget> children;

  HomeUI({
    required this.isSaving,
    required this.children,
  });

  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {

  @override
  Widget build(BuildContext context) {
    return GradientBackgroundUI(
        child: Column(
          children: [
            if (widget.isSaving)  // Show loading indicator when saving
              LinearProgressIndicator(
                backgroundColor: Colors.grey[300], // Background of the indicator
                color: Colors.deepPurpleAccent,   // Active progress bar color
              ),
            
            // Display list of contacts if available
            Expanded(
              child: widget.children[0],
            ),
          ],
        ),
    );
  }
}