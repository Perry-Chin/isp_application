// ignore_for_file: use_super_parameters, library_private_types_in_public_api

import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String hinttext; // Hint text for textfield
  final String labeltext; // Label text for textfield
  final bool obscuretext; // Flag to determine if the textfield is for a password (obscured)
  final FloatingLabelBehavior floatingLabelBehavior; // Floating label behavior for textfield
  final TextEditingController controller; // Controller for textfield

  // Constructor
  const MyTextField({
    Key? key,
    required this.hinttext,
    required this.labeltext,
    required this.obscuretext,
    required this.floatingLabelBehavior,
    required this.controller,
  }) : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _isPasswordVisible = false; // Boolean flag to track password visibility

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller, // Set controller for textfield
      decoration: InputDecoration(
        labelText: widget.labeltext, // Set label text
        floatingLabelBehavior: widget.floatingLabelBehavior, // Set floating label behavior
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
        hintText: widget.hinttext, // Set hint text
        suffixIcon: widget.obscuretext // Add suffix icon only if the field is for a password
          ? IconButton(
              icon: _isPasswordVisible
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible; // Toggle password visibility
                });
              },
            )
          : null, // If not a password field, suffix icon is null
      ),
      obscureText: widget.obscuretext ? !_isPasswordVisible : false, // Toggle password visibility based on flag
    );
  }
}