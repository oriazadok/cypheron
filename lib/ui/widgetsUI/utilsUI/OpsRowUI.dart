import 'package:flutter/material.dart';

class OpsRowUI extends StatelessWidget {
  final List<Widget> options; // List of action widgets (e.g., IconButtons)

  const OpsRowUI({
    Key? key,
    required this.options,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[900], // Dark background color
          borderRadius: BorderRadius.circular(16), // Smooth corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6), // Deeper shadow
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: Colors.grey[700]!, // Slight border for a cleaner look
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: options
              .map(
                (option) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[800], // Slightly lighter dark circle
                    shape: BoxShape.circle, // Circular button background
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 6,
                        offset: Offset(0, 3), // Inner shadow effect
                      ),
                    ],
                  ),
                  child: option,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
