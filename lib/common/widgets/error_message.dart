// Display error messages to the user

import 'package:flutter/material.dart';

// Function to display an error message
void errorMessage(String message, BuildContext context) {
  // Show a Snackbar with the message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating, // Floating Snackbar behavior
      content: Text(message), // Message to display
      backgroundColor: Colors.red, // Background color for Snackbar
    ),
  );
}