import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../data/data.dart';
import '../storage/storage.dart';

class RoutePaymentMiddleware extends GetMiddleware {
  Future<void> createPaymentDocument(String? docId, double? totalCost) async {
    
    final token = UserStore.to.token;

    // Create payment document
    final payment = PaymentData(
      uid: token,
      serviceid: docId,
      amount: totalCost,
      timestamp: Timestamp.now(),
      income: true,
      dismiss: false,
    );

    print("Payment: ");
    print(token);
    print(payment);

    // Set data in Firestore document
    await FirebaseFirestore.instance.collection('users').doc(token).collection("payment")
      .withConverter(
        fromFirestore: PaymentData.fromFirestore, 
        toFirestore: (PaymentData paymentData, options) => paymentData.toFirestore()
      )
      .add(payment);
  }
}