import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String? reviewId;
  final String serviceId;
  final String fromUid;
  final String toUid;
  final double rating;
  final String reviewText;
  final Timestamp timestamp;
  final String serviceType;
  String? fromUsername;
  String? fromPhotoUrl;

  Review({
    this.reviewId,
    required this.serviceId,
    required this.fromUid,
    required this.toUid,
    required this.rating,
    required this.reviewText,
    required this.timestamp,
    required this.serviceType,
    this.fromUsername,
    this.fromPhotoUrl,
  });

  factory Review.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Review(
      reviewId: snapshot.id,
      serviceId: data['service_id'],
      fromUid: data['from_uid'],
      toUid: data['to_uid'],
      rating: data['rating'],
      reviewText: data['review_text'],
      timestamp: data['timestamp'],
      serviceType: data['service_type'],
      fromUsername: data['from_username'],
      fromPhotoUrl: data['from_photo_url'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (reviewId != null) 'review_id': reviewId,
      'service_id': serviceId,
      'from_uid': fromUid,
      'to_uid': toUid,
      'rating': rating,
      'review_text': reviewText,
      'timestamp': timestamp,
      'service_type': serviceType,
      if (fromUsername != null) 'from_username': fromUsername,
      if (fromPhotoUrl != null) 'from_photo_url': fromPhotoUrl,
    };
  }
}
