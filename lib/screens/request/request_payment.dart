// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  static Future<void> initPaymentSheet(context, {required String email, required int amount}) async {
    try {
      // Create payment intent on the server
      final response = await http.post(
        Uri.parse('https://us-central1-event-app-c8e35.cloudfunctions.net/stripePaymentIntentRequest'),
        body: {
          'email': email,
          'amount': amount.toString(),
        }
      );

      final jsonResponse = jsonDecode(response.body);

      // Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: jsonResponse['paymentIntent'],
          merchantDisplayName: 'Flutter Stripe Store Demo',
          customerId: jsonResponse['customer'],
          customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
          style: ThemeMode.dark,
          billingDetails: const BillingDetails(
            address: Address(
              city: '', country: 'SG', state: '', 
              line1: '', line2: '', postalCode: '',
            )
          )
        ),
      );

      // Display payment sheet
      await Stripe.instance.presentPaymentSheet();

    } catch (e) {
      print('Error making payment: $e');
      throw Exception('Payment cancelled');
    }
  }
}