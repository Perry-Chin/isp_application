import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/values/values.dart';
import '../detail_index.dart';

class DatetimeField extends StatelessWidget {
  final DetailController controller;

  const DatetimeField({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 18.0, bottom: 18, left: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: AppColor.secondaryColor,
            width: 1.5
          ),
          color: Colors.white,
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_month_outlined, size: 20, color: Colors.black),
            const SizedBox(width: 10),
            Text(
              controller.state.serviceList.isNotEmpty
                ? controller.state.serviceList.first.data().date ?? "date"
                : "date",
              style: GoogleFonts.poppins(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w400),
            ),
            const SizedBox(width: 10),
            Text(
              controller.state.serviceList.isNotEmpty
                ? controller.state.serviceList.first.data().starttime ?? "time"
                : "time",
              style: GoogleFonts.poppins(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w400),
            ),
            const SizedBox(width: 15),
          ],
        ),
      ),
    );
  }
}
