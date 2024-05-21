// ignore_for_file: use_super_parameters, library_private_types_in_public_api

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:isp_application/common/values/color.dart';

class MyTextField extends StatefulWidget {
  final String hinttext; // Hint text for textfield
  final String labeltext; // Label text for textfield
  final IconData prefixicon; // Prefix icon for textfield
  final TextEditingController controller; // Controller for textfield
  final bool obscuretext; // Flag to determine if the textfield is for a password (obscured)
  final bool? readOnly;
  final int? maxLines;
  final void Function()? onTap;

  // Constructor
  const MyTextField({
    Key? key,
    required this.hinttext,
    required this.labeltext,
    required this.prefixicon,
    required this.controller,
    required this.obscuretext,
    this.readOnly,
    this.maxLines = 1,
    this.onTap,
  }) : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _isPasswordVisible = false; // Boolean flag to track password visibility
  @override
  Widget build(BuildContext context) {
    bool isPasswordField = widget.obscuretext;
    return FadeInUp(
      child: Container(
        color: Colors.white,
        child: TextField(
          controller: widget.controller, // Set controller for textfield
          minLines: 1,
          maxLines: widget.maxLines,
          onTap: widget.onTap,
          readOnly: widget.readOnly ?? false,
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
              borderSide: const BorderSide(color: AppColor.secondaryColor, width: 1.5),
              borderRadius: BorderRadius.circular(10.0),
            ),
            floatingLabelStyle: const TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColor.secondaryColor, width: 1.5),
              borderRadius: BorderRadius.circular(10.0),
            ),
            suffixIcon: isPasswordField
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
              : null, // If not a password field or obscuretext is null or false, suffix icon is null
          ),
          obscureText: isPasswordField && !_isPasswordVisible, // Ensure text is not obscured if field is multiline
        ),
      )
    );
  }
}