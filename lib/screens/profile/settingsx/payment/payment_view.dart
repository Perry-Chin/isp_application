import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';

import '../../../../common/values/values.dart';
import 'payment_index.dart';

class PaymentPage extends GetView<PaymentController> {
  const PaymentPage({super.key});

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      title: const Text("Payment History"),
      backgroundColor: AppColor.secondaryColor,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => CreditCardWidget(
              cardNumber: "4242422424242424",
              expiryDate: "04/24",
              cardHolderName: controller.user.value?.username ?? "",
              cvvCode: "123",
              showBackView: false,
              obscureCardNumber: true,
              isHolderNameVisible: true,
              chipColor: Color(0xFFD4AF37),
              onCreditCardWidgetChange: (CreditCardBrand) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, top: 8.0),
            child: Text(
              "Recent Payments", 
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}