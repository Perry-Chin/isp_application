import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
    this.suffixIcon, // Add this line
  }) : super(key: key);

  final String hinttext;
  final String labeltext;
  final IconData prefixicon;
  final TextEditingController textController;
  final bool? obscuretext;
  final bool? readOnly;
  final int? maxLines;
  final TextInputType? keyboardType;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  final Widget? suffixIcon; // Add this line

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: TextFormField(
        onTap: onTap,
        minLines: 1,
        maxLines: maxLines,
        controller: textController,
        readOnly: readOnly ?? false,
        cursorColor: Colors.black,
        keyboardType: keyboardType,
        obscureText: obscuretext ?? false, // Add this line
        style: GoogleFonts.poppins(),
        decoration: InputDecoration(
          labelText: labeltext,
          hintText: hinttext,
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Icon(prefixicon, color: Colors.black, size: 20),
          ),
          suffixIcon: suffixIcon,
        ),
        validator: validator),
    );
  }
}
