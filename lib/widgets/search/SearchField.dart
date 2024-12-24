import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final Function(String) onChanged; // Callback for text change
  final String hintText;

  const SearchField({
    Key? key,
    required this.onChanged,
    this.hintText = 'Search contacts...', // Default hint text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8), // Rounded corners
        color: Colors.white, // White background
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 32, // Reduced height for the TextField
          maxHeight: 42, // Ensures consistent compact height
        ),
        child: TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8), // Rounded border
              borderSide: BorderSide.none, // No border line
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12), // Compact padding
          ),
          style: const TextStyle(fontSize: 14), // Font size for text
          autofocus: true,
        ),
      ),
    );
  }
}
