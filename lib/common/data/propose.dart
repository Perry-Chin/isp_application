import 'package:cloud_firestore/cloud_firestore.dart';

class ProposeData {
  final String start_time;
  final Timestamp timestamp;
  final String userid;

  ProposeData({
    required this.start_time,
    required this.timestamp,
    required this.userid,
  });

  // Factory method to convert Firestore document snapshot to ProposeData instance
  factory ProposeData.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return ProposeData(
      start_time: data['start_time'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      userid: data['userid'] ?? '',
    );
  }

  // Convert ProposeData instance to Firestore compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'start_time': start_time,
      'timestamp': timestamp,
      'userid': userid,
    };
  }
}
