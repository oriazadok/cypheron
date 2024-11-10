import 'package:flutter/material.dart';

/// Provides the common style for contact cards in the ContactList widget.
class ContactCardStyle {
  static Card buildContactCard({
    required BuildContext context,
    required Widget leading,
    required String title,
    required VoidCallback onTap,
  }) {
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
