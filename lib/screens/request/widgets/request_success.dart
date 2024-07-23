import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../common/values/values.dart';
import '../../../common/widgets/widgets.dart';
import '../request_index.dart';

Widget requestSuccess(RequestController controller, BuildContext context) {
  return Stack(
    children: [
      Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Request submitted!",
                style: GoogleFonts.poppins(
                  color: AppColor.secondaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.sp
                )
              ),
              Lottie.asset('assets/animations/success.json',
                  width: 250, height: 250, repeat: false),
              const SizedBox(height: 20),
              ApplyButton(
                onPressed: () {
                  controller.clearForm();
                },
                buttonText: "Reset",
                buttonWidth: double.infinity,
                textAlignment: Alignment.center
              )
            ],
          ),
        ),
      ),
      Lottie.asset(
        "assets/animations/confetti.json",
        width: MediaQuery.sizeOf(context).height,
        height: MediaQuery.sizeOf(context).width,
        fit: BoxFit.cover,
      )
    ],
  );
}