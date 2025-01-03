import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/values/values.dart';

Future contctpg(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (BuildContext bc) {
      return ContactPage();
    },
  );
}

// ignore: must_be_immutable
class ContactPage extends StatelessWidget {
  final String phoneNumber =
      '8768 9011'; // Replace with the actual phone number
  final String emailAddress =
      'furfriends23@gmail.com'; // Replace with the actual email address
  String selectedFeedbackOption = "General Feedback";

  ContactPage({super.key});

  void _launchEmail(String emailAddress) async {
    final emailLaunchUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Could not launch $emailLaunchUri';
    }
  }

  void _launchPhoneCall(String phoneNumber) async {
    final phoneCallUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(phoneCallUri)) {
      await launchUrl(phoneCallUri);
    } else {
      throw 'Could not launch $phoneCallUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250, // Set the desired height of the container
      child: Container(
        decoration: const BoxDecoration(
          color: AppColor.secondaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ), // Rounded corners
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Contact Us",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 27,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Don't worry, we're here to assist you!",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w300,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  const RotatingImage(), // Rotating image widget
                ],
              ),
              const SizedBox(height: 3), // Added space between the image and options
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => _launchEmail(emailAddress),
                    child: SizedBox(
                      width: 100, // Set desired width of the container
                      child: Container(
                        height: 40, // Reduced height of the container
                        decoration: BoxDecoration(
                          color: const Color(0xFFC6A799), 
                          borderRadius: BorderRadius.circular(20), // Rounded corners
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.email, color: Colors.white), // Email icon
                            const SizedBox(width: 5), // Add spacing between icon and text
                            Text(
                              'Email',
                              style: GoogleFonts.poppins(
                                color: Colors.white, 
                                fontSize: 16, 
                              ),
                            ), // Text 'Email'
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12), // Added space between the options
                  GestureDetector(
                    onTap: () => _launchPhoneCall(phoneNumber),
                    child: SizedBox(
                      width: 100, // Set desired width of the container
                      child: Container(
                        height: 40, // Reduced height of the container
                        decoration: BoxDecoration(
                          color: const Color(0xFFC6A799), // Container background color
                          borderRadius: BorderRadius.circular(20), // Rounded corners
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.phone, color: Colors.white), // Phone icon
                            const SizedBox(width: 5), // Add spacing between icon and text
                            Text(
                              'Call Us',
                              style: GoogleFonts.poppins(
                                color: Colors.white, 
                                fontSize: 16, 
                              ),
                            ), // Text 'Call Us'
                          ],
                        ),
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

class RotatingImage extends StatefulWidget {
  const RotatingImage({super.key});

  @override
  State<RotatingImage> createState() => _RotatingImageState();
}

class _RotatingImageState extends State<RotatingImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: ClipOval(
        child: Image.asset(
          'assets/images/logo_bg.png',
          width: 100,
          height: 100,
        ),
      ),
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2.0 * 3.14159,
          child: child,
        );
      },
    );
  }
}
