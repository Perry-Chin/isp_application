import 'package:cloud_functions/cloud_functions.dart';

Future<dynamic> createPaymentIntent(int amount) async {
  try {
    final res = await FirebaseFunctions.instance
        .httpsCallable('createPaymentIntent')
        .call(<String, dynamic>{
          'amount': amount,
        });

    // Handle response data
    return res.data;
  } catch (e) {
    // Handle any errors
    print('Error creating payment intent: $e');
    return null; // Or throw an error, depending on your use case
  }
}


