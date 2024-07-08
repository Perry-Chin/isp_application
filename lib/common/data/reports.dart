import 'package:cloud_firestore/cloud_firestore.dart';

class ReportData {
  final String? fromUid;
  final String? reportDesc;
  final Timestamp? timestamp;
  final String? toUid;
  final String? userReportId;
  final int? userReportCount;

  ReportData({
    this.fromUid,
    this.reportDesc,
    this.timestamp,
    this.toUid,
    this.userReportId,
    this.userReportCount,
  });

  factory ReportData.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ReportData(
      fromUid: data?['from_uid'],
      reportDesc: data?['report_Desc'],
      timestamp: data?['timestamp'],
      toUid: data?['to_uid'],
      userReportId: data?['user_Report_id'],
      userReportCount: data?['user_report_count'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (fromUid != null) "from_uid": fromUid,
      if (reportDesc != null) "report_Desc": reportDesc,
      if (timestamp != null) "timestamp": timestamp,
      if (toUid != null) "to_uid": toUid,
      if (userReportId != null) "user_Report_id": userReportId,
      if (userReportCount != null) "user_report_count": userReportCount,
    };
  }
}
