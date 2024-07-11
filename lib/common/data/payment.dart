import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentData {

  final String? uid;
  final String? serviceid;
  final num? amount;
  final Timestamp? timestamp;
  final bool? income;
  final bool? dismiss;

  PaymentData({
    this.uid,
    this.serviceid,
    this.amount,
    this.timestamp,
    this.income,
    this.dismiss,
  });

  factory PaymentData.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return PaymentData(
      uid: data?['user_id'],
      serviceid: data?['service_id'],
      amount: data?['amount'],
      timestamp: data?['timestamp'],
      income: data?['income'],
      dismiss: data?['dismiss'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (uid != null) "user_id": uid,
      if (serviceid != null) "service_id": serviceid,
      if (amount != null) "amount": amount,
      if (timestamp != null) "timestamp": timestamp,
      if (income != null) "income": income,
      if (dismiss != null) "dismiss": dismiss,
    };
  }
}
