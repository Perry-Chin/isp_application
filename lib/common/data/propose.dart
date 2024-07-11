import 'package:cloud_firestore/cloud_firestore.dart';
class ProposeData {
  final String? startTime;
  final Timestamp? timestamp;
  final String? userid;

  ProposeData({
    required this.startTime,
    required this.timestamp,
    required this.userid,
  });

  factory ProposeData.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ProposeData(
      startTime: data?['start_time'],
      timestamp: data?['timestamp'] ?? Timestamp.now(),
      userid: data?['userid'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (startTime != null) "start_time": startTime,
      if (timestamp != null) "timestamp": timestamp,
      if (userid != null) "userid": userid,
    };
  }
}