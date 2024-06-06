import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/data/user.dart';
import '../schedule/schedule_view.dart';
import 'detail_index.dart';

Future confirmpg(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (BuildContext bc) {
      // Assuming you have an instance of UserData named userDataInstance
      final userDataInstance = UserData(); // Replace this with your actual instance
      return ConfirmPage(userData: userDataInstance);
    },
  );
}


class ConfirmPage extends StatelessWidget {
  final UserData? userData;

  const ConfirmPage({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: GetBuilder<DetailController>(
          init: DetailController(),
          builder: (controller) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "Confirm your booking",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          fontFamily: 'Open Sans',
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Once submitted, BuzzBuddy will send a confirmation to both parties for service to be carried out.",
                      style: TextStyle(fontSize: 15, fontFamily: 'Open Sans', fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(height: 15),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Date & Time",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            fontFamily: 'Open Sans',
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey[200],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Text(
                              controller.state.serviceList.isNotEmpty
                                  ? controller.state.serviceList.first
                                          .data()
                                          .date ??
                                      "date"
                                  : "date",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              controller.state.serviceList.isNotEmpty
                                  ? controller.state.serviceList.first
                                          .data()
                                          .time ??
                                      "time"
                                  : "time",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Total fees",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        fontFamily: 'Open Sans',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey[200],
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Total Payout",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      "\$$totalCost",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                );
                              })),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Subtotal"),
                                        Text("\$$subtotal"),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Tax Fee"),
                                        Text("\$$taxFee"),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Total"),
                                        Text(
                                          "\$$totalCost",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
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
                                    const Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Payment Method",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            SizedBox(height: 5),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Image(
                                                    image: AssetImage(
                                                        "assets/images/paynow.png"),
                                                    width: 24,
                                                    height: 24,
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    "PayNow",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              }),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Fee Breakdown',
                                style: TextStyle(color: Colors.blue),
                              ),
                              IconButton(
                                onPressed: () {
                                  controller.togglePaymentSection();
                                },
                                icon: Icon(controller.showPaymentSection
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Requester',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blueGrey,
                              child: Icon(
                                Icons.person,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      userData?.username ?? "Username",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    SizedBox(width: 12),
                                    RatedStar(
                                      rating: 3.5,
                                      starColor: Colors.yellow,
                                    ),
                                  ],
                                ),
                                Text(
                                  'user@mail.com',
                                  style: TextStyle(fontSize: 17),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      height: 38,
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // Add your onPressed logic here
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color.fromRGBO(
                            44,
                            68,
                            138,
                            1.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13.0),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
