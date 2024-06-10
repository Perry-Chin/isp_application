import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String fromUid;
  final int rating;
  final String reviewId;
  final String reviewText;
  final String serviceId;
  final String serviceType;
  final Timestamp timestamp;
  final String toUid;
  String? fromUsername;
  String? fromPhotoUrl;

  Review({
    required this.fromUid,
    required this.rating,
    required this.reviewId,
    required this.reviewText,
    required this.serviceId,
    required this.serviceType,
    required this.timestamp,
    required this.toUid,
    this.fromUsername,
    this.fromPhotoUrl,
  });

  factory Review.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return Review(
      fromUid: data['from_uid'],
      rating: data['rating'],
      reviewId: data['review_id'],
      reviewText: data['review_text'],
      serviceId: data['service_id'],
      serviceType: data['service_type'],
      timestamp: data['timestamp'],
      toUid: data['to_uid'],
    );
  }
}
