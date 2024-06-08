import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common/values/values.dart';
import '../../../common/values/color.dart';

Future contctpg(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext bc) {
      return ContactPage();
    },
  );
}

class ContactPage extends StatelessWidget {
  final String phoneNumber =
      '8768 9011'; // Replace with the actual phone number
  final String emailAddress =
      'furfriends23@gmail.com'; // Replace with the actual email address
  String selectedFeedbackOption = "General Feedback";

  ContactPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250, // Set the desired height of the container
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green, // Background color of the container
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Contact Us!",
                        style: TextStyle(
                          fontFamily: "Open Sans",
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "Don't worry, we're here to assist you!",
                        style: TextStyle(
                          fontFamily: "Open Sans",
                          fontWeight: FontWeight.w300,
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ClipOval(
                    child: Image(
                      image: AssetImage('assets/images/logo_bg.png'),
                      width: 120,
                      height: 120,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12), // Added space between the image and options
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: 40, // Reduced height of the container
                      decoration: BoxDecoration(
                        color: Colors.blue, // Container background color
                        borderRadius: BorderRadius.circular(20), // Rounded corners
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.email, color: Colors.white), // Email icon
                          SizedBox(width: 5), // Add spacing between icon and text
                          Text(
                            'Email',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ), // Text 'Email'
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12), // Added space between the options
                  Expanded(
                    child: Container(
                      height: 40, // Reduced height of the container
                      decoration: BoxDecoration(
                        color: Colors.blue, // Container background color
                        borderRadius: BorderRadius.circular(20), // Rounded corners
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone, color: Colors.white), // Phone icon
                          SizedBox(width: 5), // Add spacing between icon and text
                          Text(
                            'Call Us',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ), // Text 'Call Us'
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



  // Function to launch a phone call
//   void _launchPhoneCall(String phoneNumber) async {
//     final phoneCallUrl = Uri.parse('tel:$phoneNumber');
//     if (await canLaunchUrl(phoneCallUrl)) {
//       await launchUrl(phoneCallUrl);
//     } else {
//       throw 'Could not launch $phoneCallUrl';
//     }
//   }

//   void _launchEmail(String emailAddress) async {
//     final emailLaunchUri = Uri.parse('mailto:$emailAddress');
//     if (await canLaunchUrl(emailLaunchUri)) {
//       await launchUrl(emailLaunchUri);
//     } else {
//       throw 'Could not launch $emailLaunchUri';
//     }
//   }
// }
