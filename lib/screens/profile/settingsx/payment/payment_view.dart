// ignore_for_file: avoid_types_as_parameter_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';

import '../../../../common/values/values.dart';
import 'payment_index.dart';

class PaymentPage extends GetView<PaymentController> {
  const PaymentPage({super.key});

  AppBar _buildAppBar(context) {
    return AppBar(
      title: const Text("Payment History"),
      actions: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: IconButton(
            onPressed: () => paymentFilter(context),
            icon: const Icon(Icons.filter_list),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => CreditCardWidget(
                cardNumber: "4242422424242424",
                expiryDate: "04/24",
                cardHolderName: controller.user.value?.username ?? 'Loading...',
                cvvCode: "123",
                showBackView: false,
                obscureCardNumber: true,
                isHolderNameVisible: true,
                chipColor: const Color(0xFFD4AF37),
                onCreditCardWidgetChange: (CreditCardBrand) {},
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(
                thickness: 2,
                height: 15,
                color: Colors.black12,
              ),
            ),
            const Expanded(
              child: PaymentList(),
            ),
          ],
        ),
      ),
    );
  }
}
