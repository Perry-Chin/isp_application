import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../common/routes/routes.dart';
import '../../common/theme/custom/custom_theme.dart';
import '../../common/values/values.dart';
import '../../common/widgets/widgets.dart';
import 'detail_index.dart';
import '../home/home_controller.dart'; // Import the HomeController

Future<void> proposeNewPage(BuildContext context) async {
  showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return const ProposeTimeSheet();
      },
      backgroundColor: AppColor.backgroundColor);
}

class ProposeTimeSheet extends StatefulWidget {
  const ProposeTimeSheet({Key? key}) : super(key: key);

  @override
  State<ProposeTimeSheet> createState() => _ProposeTimeSheetState();
}

class _ProposeTimeSheetState extends State<ProposeTimeSheet> {
  final TextEditingController _startController = TextEditingController();

  @override
  void dispose() {
    _startController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final now = DateTime.now();
      final selectedTime =
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      final formattedTime = DateFormat('h:mm a').format(
          selectedTime); // Using 'h:mm a' for 12-hour format without leading zero
      setState(() {
        controller.text = formattedTime;
      });
    }
  }

  Widget _buildOriginalDateTimeSection(DetailController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Propose Time",
              style: CustomTextTheme.lightTheme.labelMedium?.copyWith(
                fontSize: 24
              )
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "Once submitted, we will share your proposed time with the Requester for their confirmation.",
            style: GoogleFonts.poppins(
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 15),
          Text('Original Time', style: CustomTextTheme.lightTheme.labelMedium?.copyWith(fontSize: 18)),
          const SizedBox(height: 15),
          FadeInUp(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 18.0, bottom: 18, left: 13),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: AppColor.secondaryColor, width: 1.5),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time_outlined,
                      size: 20, color: Colors.black),
                  const SizedBox(width: 15),
                  Text(
                    controller.state.serviceList.isNotEmpty
                        ? controller.state.serviceList.first.data().starttime ??
                            "time"
                        : "time",
                    style: GoogleFonts.poppins(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProposeTimeSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Propose Time",
            style: CustomTextTheme.lightTheme.labelMedium?.copyWith(fontSize: 18)
          ),
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: MyTextField(
                  hinttext: 'New Time',
                  labeltext: 'New Time',
                  prefixicon: Icons.access_time_outlined,
                  textController: _startController,
                  obscuretext: false,
                  readOnly: true,
                  onTap: () => _selectTime(context, _startController),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(
      BuildContext context, DetailController controller, String startTime) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text(
              "Do note that only the start time of service changes, duration of service will stay the same."),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // Call controller method to create propose document
                await controller.createProposeDocument(startTime);
                Get.back();
                Navigator.of(context).pop(); // Close confirmation dialog
                Get.offAllNamed(AppRoutes
                    .navbar); // Navigate to home page and remove all previous routes
                Get.find<HomeController>()
                    .onRefresh(); // Call refreshData on HomeController
              },
              child: const Text(AppText.confirmation),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close confirmation dialog
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContinueButton(
      BuildContext context, DetailController controller) {
    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: ApplyButton(
              onPressed: () {
                final String startTime = _startController.text;
                final String originalStartTime =
                    controller.state.serviceList.isNotEmpty
                        ? controller.state.serviceList.first.data().starttime ??
                            "time"
                        : "time";

                if (startTime.isEmpty) {
                  _showErrorDialog(
                      context, "The proposed start time cannot be empty.");
                } else if (startTime == originalStartTime) {
                  _showErrorDialog(context,
                      "The proposed start time cannot be the same as the original start time.");
                } else {
                  _showConfirmationDialog(context, controller, startTime);
                }
              },
              buttonText: "Continue",
              buttonWidth: double.infinity,
              textAlignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(AppText.error),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(AppText.confirmation),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 8,
          right: 8,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom +
              10, // Adjust bottom padding as needed
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopIndicator(),
            _buildOriginalDateTimeSection(Get.find<DetailController>()),
            _buildProposeTimeSection(context),
            _buildContinueButton(context, Get.find<DetailController>()),
          ],
        ),
      ),
    );
  }
}
