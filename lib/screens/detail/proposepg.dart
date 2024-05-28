import 'package:flutter/material.dart';

Future<void> proposeNewPage(BuildContext context) async {
  showModalBottomSheet(
    context: context, 
    builder: (BuildContext bc) {
      return const SafeArea(
        child: Wrap(
          children: [
            // Add your content here
            ListTile(
              leading: Icon(Icons.access_time),
              title: Text('Propose a new time'),
            ),
            Text(
              "Once submitted, BuzzBuddy will share your proposed time with the Requester for their confirmation.",
            )
          ],
        ),
      );
    },
  );
}
