
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailTitle extends StatelessWidget {
  const DetailTitle({
    super.key,
    required this.name,
  });

  final String? name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 5),
      child: Text(
        name ?? "Service Name",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 27,
        ),
      ),
    );
  }
}