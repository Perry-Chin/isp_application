// Main button for the app

import 'package:flutter/material.dart';

import '../values/values.dart';

class ApplyButton extends StatelessWidget {
  // Define properties for the button
  final VoidCallback onPressed;
  final String buttonText;
  final double buttonWidth;

  // Constructor
  const ApplyButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
    required this.buttonWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Return a centered elevated button
    return Center(
      child: ElevatedButton(
        onPressed: onPressed, // Action to be performed when pressed
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.secondaryColor, // Use primary color for background
          elevation: 4, // Small shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Apply rounded corners
          ),
        ),
        child: Container(
          width: buttonWidth, // Set button width
          padding: const EdgeInsets.symmetric(vertical: 15), // Set padding
          child: Center(
            child: Text(
              buttonText, // Display text on the button
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Set text color to white
              ),
            ),
          ),
        ),
      ),
    );
  }
}