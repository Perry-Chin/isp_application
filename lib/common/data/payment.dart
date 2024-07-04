import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentData {

  final String? uid;
  final String? serviceid;
  final double? amount;
  final Timestamp? timestamp;
  final bool? requested;
  final bool? paid;

  PaymentData({
    this.uid,
    this.serviceid,
    this.amount,
    this.timestamp,
    this.requested,
    this.paid,
  });

  factory PaymentData.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return PaymentData(
      uid: data?['uid'],
      serviceid: data?['serviceid'],
      amount: data?['amount'],
      timestamp: data?['timestamp'],
      requested: data?['requested'],
      paid: data?['paid'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (uid != null) "uid": uid,
      if (serviceid != null) "serviceid": serviceid,
      if (amount != null) "amount": amount,
      if (timestamp != null) "timestamp": timestamp,
      if (requested != null) "requested": requested,
      if (paid != null) "paid": paid,
    };
  }
}
