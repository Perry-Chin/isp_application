import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:isp_application/common/widgets/button.dart';
import 'detail_controller.dart';

Future<void> proposeNewPage(BuildContext context) async {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    builder: (BuildContext bc) {
      return ProposeTimeSheet();
    },
  );
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

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
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
      final selectedTime = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      final formattedTime = DateFormat('h:mm a').format(selectedTime); // Using 'h:mm a' for 12-hour format without leading zero
      setState(() {
        controller.text = formattedTime;
      });
    }
  }

  Widget _buildOriginalDateTimeSection(DetailController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            "Propose Time",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, fontFamily: 'Open Sans'),
          ),
        ),
        const SizedBox(height: 15),
        const Text(
          "Once submitted, BuzzBuddy will share your proposed time with the Requester for their confirmation.",
          style: TextStyle(fontSize: 15, fontFamily: 'Open Sans', fontWeight: FontWeight.w300),
        ),
        const SizedBox(height: 15),
        const Text(
          'Your Original Date & Time',
          style: TextStyle(fontSize: 20, fontFamily: 'Open Sans', fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey[200],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                controller.state.serviceList.isNotEmpty ? controller.state.serviceList.first.data().date ?? "date" : "date",
                style: const TextStyle(fontSize: 16.0, color: Colors.black),
              ),
              const SizedBox(width: 10),
              Text(
                controller.state.serviceList.isNotEmpty ? controller.state.serviceList.first.data().starttime ?? "time" : "time",
                style: const TextStyle(fontSize: 16.0, color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProposeTimeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          "Propose Time",
          style: TextStyle(fontSize: 20, fontFamily: 'Open Sans', fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _selectTime(context, _startController),
                child: AbsorbPointer(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.black, width: 1.0),
                    ),
                    child: TextField(
                      controller: _startController,
                      decoration: const InputDecoration(
                        hintText: 'Start',
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showConfirmationDialog(BuildContext context, DetailController controller, String startTime) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Do note that only the start time of service changes, duration of service will stay the same."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Call controller method to create propose document
                controller.createProposeDocument(startTime);
                Get.back();
                Navigator.of(context).pop(); // Close confirmation dialog
              },
              child: const Text("OK"),
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

  Widget _buildContinueButton(BuildContext context, DetailController controller) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: ApplyButton(
              onPressed: () {
                final String startTime = _startController.text;
                final String originalStartTime = controller.state.serviceList.isNotEmpty
                    ? controller.state.serviceList.first.data().starttime ?? "time"
                    : "time";

                if (startTime == originalStartTime) {
                  _showErrorDialog(context, "The proposed start time cannot be the same as the original start time.");
                } else {
                  _showConfirmationDialog(context, controller, startTime);
                }
              },
              buttonText: "Continue",
              buttonWidth: 100,
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
          title: const Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
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
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20, // Adjust bottom padding as needed
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOriginalDateTimeSection(Get.find<DetailController>()),
            _buildProposeTimeSection(context),
            _buildContinueButton(context, Get.find<DetailController>()),
          ],
        ),
      ),
    );
  }
}
