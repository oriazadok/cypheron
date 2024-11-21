import 'package:flutter/material.dart';


import 'package:cypheron/widgets/loading/LoadingCircle.dart'; // Import the new LoadingIndicator

/// A wrapper for displaying content with consistent layout and background styling.
class MobileContactsUI extends StatelessWidget {
  final String title;
  final VoidCallback? onRefresh;
  final bool isFetching;
  final List<Map<String, dynamic>> contacts;
  final Widget refresh;
  final Widget error;

  const MobileContactsUI({
    required this.title,
    this.onRefresh,
    required this.isFetching,
    required this.contacts,
    required this.refresh,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          if (onRefresh != null)
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: onRefresh,
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1C1C1E), Color(0xFF2C2C34)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isFetching
        ? LoadingCircle()
        : contacts.isNotEmpty
          ? refresh
          : error,
      ),
    );
  }
}
