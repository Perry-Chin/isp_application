import 'package:cloud_firestore/cloud_firestore.dart';

class ProposeData {
  final String startTime;
  final Timestamp timestamp;
  final String userid;

  ProposeData({
    required this.startTime,
    required this.timestamp,
    required this.userid,
  });

  // Factory method to convert Firestore document snapshot to ProposeData instance
  factory ProposeData.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return ProposeData(
      startTime: data['start_time'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      userid: data['userid'] ?? '',
    );
  }

  // Convert ProposeData instance to Firestore compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'start_time': startTime,
      'timestamp': timestamp,
      'userid': userid,
    };
  }
}
