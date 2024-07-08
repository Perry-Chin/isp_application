import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportUserMenu extends StatelessWidget {
  final String userId;
  final String currentUserId;

  const ReportUserMenu(
      {Key? key, required this.userId, required this.currentUserId})
      : super(key: key);

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
      content: 'Are you sure you want to report this user?',
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Report'),
          onPressed: () {
            Navigator.of(context).pop();
            _reportUser(context);
          },
        ),
      ],
    );
  }

  void _reportUser(BuildContext context) async {
    try {
      final db = FirebaseFirestore.instance;
      // Check if the user has already reported this user
      var existingReports = await db
          .collection('reports')
          .where('from_uid', isEqualTo: currentUserId)
          .where('to_uid', isEqualTo: userId)
          .get();

      if (existingReports.docs.isNotEmpty) {
        _showErrorDialog(context, 'You have already reported this user');
        return;
      }

      // Create a new report
      await db.collection('reports').add({
        'from_uid': currentUserId,
        'to_uid': userId,
        'report_Desc': 'User reported',
        'timestamp': FieldValue.serverTimestamp(),
        'user_report_count': '1',
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
          onPressed: () {
            Navigator.of(context).pop();
          },
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
          onPressed: () {
            Navigator.of(context).pop();
          },
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
