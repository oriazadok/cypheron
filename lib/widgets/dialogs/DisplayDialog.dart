import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/IconsUI.dart';

Future<void> displaydialog(
  BuildContext context,
  String title,
  String decryptedBody, {
  Duration duration = const Duration(seconds: 60),
}) async {
  int remainingTime = duration.inSeconds;

  // Show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          // Start the countdown
          Future.delayed(Duration(seconds: 1), () {
            if (remainingTime > 0 && Navigator.of(context).canPop()) {
              setState(() {
                remainingTime--;
              });
            } else if (remainingTime == 0 && Navigator.of(context).canPop()) {
              Navigator.of(context).pop(); // Close the dialog when time runs out
            }
          });

          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: Text(decryptedBody),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Display the timer on the left
                  Text(
                    "$remainingTime s",
                    // style: TextStyle(fontSize: 14, color: Colors.redAccent),
                  ),
                  Row(
                    children: [
                      // Copy button
                      IconsUI(
                        context: context,
                        type: "copy",
                        isButton: true,
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
}
