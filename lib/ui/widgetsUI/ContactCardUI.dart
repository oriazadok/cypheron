import 'package:flutter/material.dart';

/// A reusable widget for displaying contact cards with a consistent style.
class ContactCard extends StatelessWidget {
  final Widget leading;
  final String title;
  final VoidCallback onTap;

  /// Constructor for the ContactCard widget.
  const ContactCard({
    Key? key,
    required this.leading,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1C1C1C),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: onTap,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          leading: leading,
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
            size: 16,
          ),
        ),
      ),
    );
  }
}
