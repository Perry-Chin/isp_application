import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/values/values.dart';
import '../detail_index.dart';

class PaymentDetail extends StatelessWidget {
  final DetailController controller;

  const PaymentDetail({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        border: Border.all(
          color: AppColor.secondaryColor,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 5,
              top: 5,
              bottom: 10,
            ),
            child: Obx(() {
              final totalCost = controller.totalCost.value;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Payout",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    "\$$totalCost",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ],
              );
            }),
          ),
          Visibility(
            visible: controller.showPaymentSection,
            child: Padding(
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
                        Text("\$$subtotal", style: GoogleFonts.poppins()),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Tax Fee", style: GoogleFonts.poppins()),
                        Text("\$$taxFee", style: GoogleFonts.poppins()),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total"),
                        Text(
                          "\$$totalCost",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Image(
                                    image: AssetImage("assets/images/paynow.png"),
                                    width: 24,
                                    height: 24,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "PayNow",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Fee Breakdown',
                style: GoogleFonts.poppins(color: Colors.blue),
              ),
              IconButton(
                onPressed: () {
                  controller.togglePaymentSection();
                },
                icon: Icon(
                  controller.showPaymentSection
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}