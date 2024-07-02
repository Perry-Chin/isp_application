import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/values/values.dart';
import 'payment_index.dart';

class PaymentPage extends GetView<PaymentController> {
  const PaymentPage({super.key});

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: const Text("Payment History"),
      backgroundColor: AppColor.secondaryColor,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
    );
  }
}