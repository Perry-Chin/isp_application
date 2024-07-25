import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class MyDropdownField extends StatefulWidget {
  final String hintText;
  final String labelText;
  final IconData prefixIcon;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? value;
  final String? Function(String?)? validator;

  const MyDropdownField({
    Key? key,
    required this.hintText,
    required this.labelText,
    required this.prefixIcon,
    required this.items,
    required this.onChanged,
    this.value,
    this.validator,
  }) : super(key: key);

  @override
  State<MyDropdownField> createState() => _MyDropdownFieldState();
}

class _MyDropdownFieldState extends State<MyDropdownField> {
  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white
        ),
        child: Center(
          child: DropdownButtonFormField<String>(
            value: widget.value,
            decoration: InputDecoration(
              labelText: widget.labelText,
              hintText: widget.hintText,
              labelStyle: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
              hintStyle: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 14.0,
              ),
              prefixIcon: Icon(
                widget.prefixIcon,
                color: Colors.black,
                size: 20,
              ),
              floatingLabelStyle: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 18.0,
              ),
            ),
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 14.0,
            ),
            validator: widget.validator,
            items: widget.items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            isExpanded: true,
            onChanged: widget.onChanged,
          ),
        ),
      ),
    );
  }
}