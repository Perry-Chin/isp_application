import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String reviewId;
  final String fromUid;
  final String toUid;
  final String serviceId;
  final String serviceType;
  final String reviewText;
  final int rating;
  final DateTime timestamp;
  String? username;
  String? photoUrl;
  bool isReceived = false;

  Review({
    required this.reviewId,
    required this.fromUid,
    required this.toUid,
    required this.serviceId,
    required this.serviceType,
    required this.reviewText,
    required this.rating,
    required this.timestamp,
    this.username,
    this.photoUrl,
    this.isReceived = false,
  });

  factory Review.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Review(
      reviewId: doc.id,
      fromUid: data['from_uid'],
      toUid: data['to_uid'],
      serviceId: data['service_id'],
      serviceType: data['service_type'],
      reviewText: data['review_text'],
      rating: data['rating'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'from_uid': fromUid,
      'to_uid': toUid,
      'service_id': serviceId,
      'service_type': serviceType,
      'review_text': reviewText,
      'rating': rating,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
