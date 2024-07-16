import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewData {
  final String fromUid;
  final String toUid;
  final String serviceId;
  final String serviceType;
  final String review;
  final int rating;
  final DateTime timestamp;

  ReviewData({
    required this.fromUid,
    required this.toUid,
    required this.serviceId,
    required this.serviceType,
    required this.review,
    required this.rating,
    required this.timestamp,
  });

  factory ReviewData.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ReviewData(
      fromUid: data?['from_uid'],
      toUid: data?['to_uid'],
      serviceId: data?['service_id'],
      serviceType: data?['service_type'],
      review: data?['review'],
      rating: data?['rating'],
      timestamp: (data?['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'from_uid': fromUid,
      'to_uid': toUid,
      'service_id': serviceId,
      'service_type': serviceType,
      'review': review,
      'rating': rating,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
