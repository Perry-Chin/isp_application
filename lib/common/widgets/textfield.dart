// ignore_for_file: use_super_parameters, library_private_types_in_public_api

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String hinttext; // Hint text for textfield
  final String labeltext; // Label text for textfield
  final IconData prefixicon; // Prefix icon for textfield
  final bool obscuretext; // Flag to determine if the textfield is for a password (obscured)
  final TextEditingController controller; // Controller for textfield

  // Constructor
  const MyTextField({
    Key? key,
    required this.hinttext,
    required this.labeltext,
    required this.prefixicon,
    required this.obscuretext,
    required this.controller,
  }) : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _isPasswordVisible = false; // Boolean flag to track password visibility

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: TextField(
        controller: widget.controller, // Set controller for textfield
        decoration: InputDecoration(
          labelText: widget.labeltext, // Set label text
          hintText: widget.hinttext, // Set hint text
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
          ),
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14.0,
          ),
          prefixIcon: Icon(
            widget.prefixicon, 
            color: Colors.black, 
            size: 20, 
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
            borderRadius: BorderRadius.circular(10.0),
          ),
          floatingLabelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 18.0,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 1.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
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
      )
    );
  }
}