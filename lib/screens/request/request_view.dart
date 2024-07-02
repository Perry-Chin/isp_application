// Request Page

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:isp_application/common/widgets/widgets.dart';

import '../../common/values/values.dart';
import 'request_index.dart';

class RequestPage extends GetView<RequestController> {
  Map<String, dynamic>? paymentIntent;
  RequestPage({super.key});

  createPaymentIntent() async {
    try {
      final body = {
        'amount': "1000",
        'currency': "SGD",
      };
      http.Response response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer sk_test_51PW9k609OEdaNyd6QgHUeSko1k4I8mfw6sgnZBqHdgGaFru0PibwOxAejWOM7ETDIJUlCKWXze5ME4KBBMyDdi55002kBJbgBe',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );
      print("object");
      return json.decode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  void makePayment() async {
    try {
      paymentIntent = await createPaymentIntent();

      var gpay = const PaymentSheetGooglePay(
        merchantCountryCode: 'SG',
        currencyCode: 'SG',
        testEnv: true,
      );
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          merchantDisplayName: 'Flutter Stripe Store Demo',
          style: ThemeMode.dark,
          googlePay: gpay
      ));

      displayPaymentSheet();
        
      print("objectsdfsd");
    } catch (e) {
      print('Exception: $e');
    }
  }

  void displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      print('Exception: $e');
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: const Text("Request service"),
      backgroundColor: AppColor.secondaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Reset the form when the back button is pressed
        controller.resetForm();
        return true; //Allow the back navigation
      },
      child: Scaffold(
        backgroundColor: AppColor.backgroundColor,
          appBar: _buildAppBar(),
          body: Obx(() {
            //Request submitted successfully
            if (controller.requestCompleted.value) {
              return requestSuccess(controller, context);
            } else {
              // return ApplyButton(
              //   onPressed: () => makePayment(),
              //   buttonText: "Payment", 
              //   buttonWidth: 200
              // );
              return requestForm(controller, context);
            }
          }
        )
      ),
    );
  }
}