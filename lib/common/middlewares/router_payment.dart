import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../data/data.dart';

class RoutePaymentMiddleware extends GetMiddleware {
  Future<void> createPaymentDocument(String? docId, double? totalCost, String? userId, String? userTarget, bool? income) async {
    print(docId);
    // Create payment document
    final payment = PaymentData(
      uid: userTarget,
      serviceid: docId,
      amount: totalCost,
      timestamp: Timestamp.now(),
      income: income,
      dismiss: false,
    );

    // Set data in Firestore document
    await FirebaseFirestore.instance.collection('users').doc(userId)
      .collection("payments")
      .withConverter(
        fromFirestore: PaymentData.fromFirestore, 
        toFirestore: (PaymentData paymentData, options) => paymentData.toFirestore()
      )
      .add(payment);
  }

  Future<void> updatePaymentDocument(String? docId, String? userId, String? userTarget) async {
    // Create payment document
    final payment = PaymentData(
      uid: userTarget
    );

    print(docId);
    print(userId);
    print(userTarget);

    // Set data in Firestore document
    await FirebaseFirestore.instance
      .collection('users').doc(userId).collection("payments")
      .where("service_id", isEqualTo: docId)
      .withConverter(
        fromFirestore: PaymentData.fromFirestore,
        toFirestore: (PaymentData paymentData, _) => paymentData.toFirestore(),
      )
      .get()
      .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          print("NOT EMPTY");
          // Update the first matching document
          return querySnapshot.docs.first.reference.update(payment.toFirestore());
        }
      });
  }
}