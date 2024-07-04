// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  static const String _stripeSecretKey = 'sk_test_51PW9k609OEdaNyd6QgHUeSko1k4I8mfw6sgnZBqHdgGaFru0PibwOxAejWOM7ETDIJUlCKWXze5ME4KBBMyDdi55002kBJbgBe';

  static Future<Map<String, dynamic>> createPaymentIntent(BuildContext context, String amount) async {
    try {
      final body = {
        'amount': amount,
        'currency': "SGD",
      };
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer $_stripeSecretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );
      return json.decode(response.body);
    } catch (err) {
      print('Error creating payment intent: ${err.toString()}');
      throw Exception('Failed to create payment intent');
    }
  }

  static Future<void> initializePaymentSheet(BuildContext context, Map<String, dynamic> paymentIntent) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          merchantDisplayName: 'Flutter Stripe Store Demo',
          style: ThemeMode.dark,
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'SG',
            currencyCode: 'SGD',
            testEnv: true,
          ),
          billingDetails: const BillingDetails(
            address: Address(
              city: '', country: 'SG', state: '', 
              line1: '', line2: '', postalCode: '',
            )
          )
        ),
      );
    } catch (e) {
      print('Error initializing payment sheet: $e');
      throw Exception('Failed to initialize payment sheet');
    }
  }

  static Future<void> displayPaymentSheet(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      print('Error displaying payment sheet: $e');
      throw Exception('Failed to display payment sheet');
    }
  }

  static Future<void> makePayment(BuildContext context, String amount) async {
    try {
      final paymentIntent = await createPaymentIntent(context, amount);
      await initializePaymentSheet(context, paymentIntent);
      await displayPaymentSheet(context);
    } catch (e) {
      print('Error making payment: $e');
      throw Exception('Payment failed');
    }
  }
}