import 'package:flutter/material.dart';
import 'package:cypheron/ui/generalUI/GradientBackgroundUI.dart';

/// Home screen that displays user's contacts and enables decryption of shared files.
class HomeUI extends StatefulWidget {

  final bool isSaving;
  final Widget contactList;

  HomeUI({
    required this.isSaving,
    required this.contactList,
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
              LinearProgressIndicator(),
            // Display list of contacts if available
            Expanded(
              child: widget.contactList,
            ),
          ],
        ),
    );
  }
}