import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/data/data.dart';
import '../detail_index.dart';

class FeeInfo extends StatelessWidget {
  const FeeInfo({
    super.key,
    required this.controller,
    required this.userData,
  });

  final DetailController controller;
  final UserData? userData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black26),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5, top: 5, bottom: 10),
              child: Text(
                "Total Fees",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() {
                final taxFee = controller.taxFee.value;
                final subtotal = controller.subtotal.value;
                final totalCost = controller.totalCost.value;
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Subtotal", style: GoogleFonts.poppins()), 
                        Text("\$$subtotal", style: GoogleFonts.poppins())
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Tax Fee", style: GoogleFonts.poppins()), 
                        Text("\$$taxFee", style: GoogleFonts.poppins())
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total", style: GoogleFonts.poppins()),
                        Text(
                          "\$$totalCost",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold,),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 2,
                      color: Colors.black12,
                      height: 15,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Payment Method",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Image(
                                    image: const AssetImage(
                                        "assets/images/paynow.png"),
                                    width: 24.w,
                                    height: 24.w,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "PayNow",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
