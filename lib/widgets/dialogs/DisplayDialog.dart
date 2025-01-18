import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/IconsUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/GenericTextStyleUI.dart';

Future<void> displaydialog(
  BuildContext context,
  String title,
  String decryptedBody, {
    Duration duration = const Duration(seconds: 60),
  }) async {
    int remainingTime = duration.inSeconds;
    bool isActive = true; // Track if the dialog is still active
    bool showTimer = decryptedBody != "Cypher failed"; // Hide timer if decryption failed

    // Show the dialog
    await showDialog(
      context: context,
      barrierDismissible: false, // Prevent accidental dismissal
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // Start the countdown if needed
            if (showTimer) {
              Future.delayed(Duration(seconds: 1), () {
                if (isActive && remainingTime > 0) {
                  setState(() {
                    remainingTime--;
                  });
                } else if (isActive && remainingTime == 0) {
                  Navigator.of(context).pop(); // Close the dialog when time runs out
                }
              });
            }

            return AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: Text(decryptedBody),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Display the timer only if applicable
                    if (showTimer)
                      Text(
                        "$remainingTime s",
                        style: GenericTextStyleUI.getTextStyle(TextType.time),
                      ),
                    Row(
                      children: [
                        // Copy button
                        IconsUI(
                          type: IconType.copy,
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: decryptedBody)); // Copy to clipboard
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Copied to clipboard')),
                            );
                          },
                        ),
                        // Close button
                        TextButton(
                          onPressed: () {
                            isActive = false; // Stop the timer
                            Navigator.of(context).pop(); // Manually close the dialog
                          },
                          child: Text('Close'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );

    isActive = false; // Ensure the timer stops after dialog is closed
}
