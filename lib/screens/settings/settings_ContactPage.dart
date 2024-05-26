import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/values/values.dart';
import '../../common/values/color.dart';

class ContactPage extends StatelessWidget {
  final String phoneNumber = '8768 9011'; // Replace with the actual phone number
  final String emailAddress = 'furfriends23@gmail.com'; // Replace with the actual email address

  String selectedFeedbackOption = "General Feedback";

  ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
        backgroundColor: AppColor.secondaryColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your feedback matters to us!',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: AppColor.secondaryColor,
                ),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('Call Us'),
                subtitle: Text(phoneNumber),
                onTap: () {
                  _launchPhoneCall(phoneNumber);
                },
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text('Email Us'),
                subtitle: Text(emailAddress),
                onTap: () {
                  _launchEmail(emailAddress);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to launch a phone call
void _launchPhoneCall(String phoneNumber) async {
  final phoneCallUrl = Uri.parse('tel:$phoneNumber');
  if (await canLaunchUrl(phoneCallUrl)) {
    await launch(phoneCallUrl.toString());
  } else {
    throw 'Could not launch $phoneCallUrl';
  }
}

void _launchEmail(String emailAddress) async {
  final emailLaunchUri = Uri.parse('mailto:$emailAddress');
  if (await canLaunchUrl(emailLaunchUri)) {
    await launch(emailLaunchUri.toString());
  } else {
    throw 'Could not launch $emailLaunchUri';
  }
}

}
