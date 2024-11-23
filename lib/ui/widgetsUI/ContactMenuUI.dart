import 'package:flutter/material.dart';

class ContactMenuUI extends StatelessWidget {
  
  final List<Widget> options;

  const ContactMenuUI({
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        options[0],
        SizedBox(height: 15),
        options[1],
      ],
    );
  }
}
