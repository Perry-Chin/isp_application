import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../values/values.dart';

class MyTextField extends GetView {
  const MyTextField({
    Key? key,
    required this.hinttext,
    required this.labeltext,
    required this.prefixicon,
    required this.textController,
    this.obscuretext,
    this.readOnly,
    this.maxLines = 1,
    this.keyboardType,
    this.onTap,
    this.validator,
  }) : super(key: key);

  final String hinttext; // Hint text for textfield
  final String labeltext; // Label text for textfield
  final IconData prefixicon; // Prefix icon for textfield
  final TextEditingController textController; // Controller for textfield
  final bool? obscuretext; // Flag to determine if the textfield is for a password (obscured)
  final bool? readOnly; // Flag to determine if the textfield is read-only
  final int? maxLines; // Maximum number of lines for the textfield
  final TextInputType? keyboardType; // Keyboard type
  final void Function()? onTap; // Callback function when the textfield is tapped
  final String? Function(String?)? validator; // Validator for textfield

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: TextFormField(
        onTap: onTap,
        minLines: 1,
        maxLines: maxLines,
        controller: textController, // Set controller for textfield 
        readOnly: readOnly ?? false,
        cursorColor: Colors.black,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labeltext, // Set label text
          hintText: hinttext, // Set hint
          filled: true, 
          fillColor: Colors.white,
          prefixIcon: Icon(
            prefixicon, 
            color: Colors.black, 
            size: 20
          ),
          suffixIcon: (obscuretext ?? false)
              ? IconButton(
                  icon: const Icon(Icons.remove_red_eye),
                  onPressed: () {},
                )
              : null,
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
          ),
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14.0,
          ),
          errorStyle: const TextStyle(
            color: Colors.red,
            fontSize: 14.0,
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
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: validator
      ),
    );
  }
}