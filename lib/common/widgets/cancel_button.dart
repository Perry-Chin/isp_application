// Main button for the app

import 'package:flutter/material.dart';

import '../values/values.dart';

class CancelButton extends StatelessWidget {
  // Define properties for the button
  final VoidCallback onPressed;
  final String buttonText;
  final double buttonWidth;
  final Alignment? textAlignment;

  // Constructor
  const CancelButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
    required this.buttonWidth,
    this.textAlignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Return a centered elevated button
    return ElevatedButton(
      onPressed: onPressed, // Action to be performed when pressed
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent, // Use primary color for background
        elevation: 4, // Small shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Apply rounded corners
        ),
      ),
      child: Container(
        alignment: textAlignment,
        width: buttonWidth, // Set button width
        padding: const EdgeInsets.symmetric(vertical: 18), // Set padding
        child: Text(
          buttonText, // Display text on the button
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Set text color to white
          ),
        ),
      ),
    );
  }
}