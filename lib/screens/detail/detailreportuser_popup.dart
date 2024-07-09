import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportUserMenu extends StatelessWidget {
  final String userId;
  final String currentUserId;

  const ReportUserMenu({
    Key? key,
    required this.userId,
    required this.currentUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.more_vert),
      onPressed: () => _showReportDialog(context),
    );
  }

  void _showReportDialog(BuildContext context) {
    _showDialog(
      context,
      title: 'Report User',
      content: 'Please select a reason for reporting this user:',
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('Inappropriate Content'),
          onPressed: () {
            Navigator.of(context).pop();
            _reportUser(context, 'Inappropriate Content');
          },
        ),
        TextButton(
          child: const Text('Harassment'),
          onPressed: () {
            Navigator.of(context).pop();
            _reportUser(context, 'Harassment');
          },
        ),
        TextButton(
          child: const Text('Spam'),
          onPressed: () {
            Navigator.of(context).pop();
            _reportUser(context, 'Spam');
          },
        ),
      ],
    );
  }

  Future<void> _reportUser(BuildContext context, String reportReason) async {
    try {
      final db = FirebaseFirestore.instance;
      final reportsRef = db.collection('reports');
      final userReportRef = db.collection('user_reports').doc(userId);

      // Check if the user has reported this user in the last 24 hours
      var lastDayReports = await reportsRef
          .where('from_uid', isEqualTo: currentUserId)
          .where('to_uid', isEqualTo: userId)
          .where('timestamp',
              isGreaterThan: Timestamp.fromDate(
                  DateTime.now().subtract(const Duration(days: 1))))
          .get();

      if (lastDayReports.docs.isNotEmpty) {
        _showErrorDialog(
            context, 'You can only report this user once every 24 hours.');
        return;
      }

      // Use a transaction to update both the reports collection and the user_reports document
      await db.runTransaction((transaction) async {
        // Get the current report count
        DocumentSnapshot userReportSnapshot =
            await transaction.get(userReportRef);
        int currentCount = 0;
        if (userReportSnapshot.exists) {
          currentCount =
              (userReportSnapshot.data() as Map<String, dynamic>)['count'] ?? 0;
        }

        // Increment the count
        int newCount = currentCount + 1;

        // Create a new report
        DocumentReference newReportRef = reportsRef.doc();
        transaction.set(newReportRef, {
          'from_uid': currentUserId,
          'to_uid': userId,
          'report_Desc': reportReason,
          'timestamp': FieldValue.serverTimestamp(),
          'user_report_count':
              newCount, // Include the updated count in the report
        });

        // Update the user_reports document
        transaction.set(
            userReportRef, {'count': newCount}, SetOptions(merge: true));
      });

      _showSuccessDialog(context, 'User has been reported');
    } catch (e) {
      print('Error reporting user: $e');
      _showErrorDialog(context, 'Failed to report user');
    }
  }

  void _showSuccessDialog(BuildContext context, String message) {
    _showDialog(
      context,
      title: 'Success',
      content: message,
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    _showDialog(
      context,
      title: 'Error',
      content: message,
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  void _showDialog(
    BuildContext context, {
    required String title,
    required String content,
    required List<Widget> actions,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(title),
          content: Text(content),
          actions: actions,
        );
      },
    );
  }
}
