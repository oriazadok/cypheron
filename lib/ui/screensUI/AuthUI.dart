import 'package:flutter/material.dart';

class AuthUI extends StatelessWidget {

  final Widget form;

  /// Constructor for the FittedText widget.
  AuthUI({
    required this.form,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
          child: this.form,
        ),
    );
  }
}
