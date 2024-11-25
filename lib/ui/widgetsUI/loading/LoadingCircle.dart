import 'package:flutter/material.dart';

/// A reusable widget for displaying a loading indicator with custom styling.
class LoadingCircle extends StatelessWidget {
  final Color color;

  const LoadingCircle({this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Center(
      // child: CircularProgressIndicator(color: color),
    );
  }
}
