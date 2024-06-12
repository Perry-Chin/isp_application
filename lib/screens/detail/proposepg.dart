import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:isp_application/common/widgets/button.dart';
import 'detail_controller.dart';

Future<void> proposeNewPage(BuildContext context) async {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    isScrollControlled: true,
    builder: (BuildContext bc) {
      return const ProposeTimeSheet();
    },
  );
}

class ProposeTimeSheet extends StatefulWidget {
  const ProposeTimeSheet({super.key});

  @override
  State<ProposeTimeSheet> createState() => _ProposeTimeSheetState();
}

class _ProposeTimeSheetState extends State<ProposeTimeSheet> {
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  String _totalHours = "";
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _startController.addListener(_calculateTotalHours);
    _endController.addListener(_calculateTotalHours);
  }

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final now = DateTime.now();
      final selectedTime = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      final formattedTime = DateFormat('HH:mm').format(selectedTime);
      setState(() {
        controller.text = formattedTime;
      });
    }
  }

  void _calculateTotalHours() {
    final String startText = _startController.text;
    final String endText = _endController.text;

    if (startText.isNotEmpty && endText.isNotEmpty) {
      try {
        final DateTime startTime = DateFormat('HH:mm').parse(startText);
        final DateTime endTime = DateFormat('HH:mm').parse(endText);

        // Check if start time is equal to end time
        if (startTime == endTime) {
          setState(() {
            _errorMessage = "Start time and end time cannot be equal";
          });
          return;
        }

        Duration duration = endTime.difference(startTime);
        if (duration.isNegative) {
          duration += const Duration(hours: 24);
        }

        String formattedHours;
        if (duration.inMinutes < 60) {
          formattedHours = '${duration.inMinutes} mins';
        } else {
          double totalHoursDouble = duration.inMinutes / 60.0;
          formattedHours = '${totalHoursDouble.toStringAsFixed(2).replaceAll('.', ':')} h';
        }

        setState(() {
          _totalHours = formattedHours;
          _errorMessage = ""; // Clear error message if calculation is successful
        });
      } on FormatException catch (e) {
        setState(() {
          _totalHours = e.message;
        });
      } catch (e) {
        setState(() {
          _totalHours = "An error occurred. Please try again.";
        });
      }
    } else {
      setState(() {
        _totalHours = "";
      });
    }
  }

  @override
  void dispose() {
    _startController.removeListener(_calculateTotalHours);
    _endController.removeListener(_calculateTotalHours);
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Material(
        child: SafeArea(
          child: GetBuilder<DetailController>(
            init: DetailController(),
            builder: (controller) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          "Propose Time",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              fontFamily: 'Open Sans'),
                        ),
                      ),
                      const SizedBox(height: 15),
                      if (_errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            _errorMessage,
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const SizedBox(height: 15),
                      const Text(
                        "Once submitted, BuzzBuddy will share your proposed time with the Requester for their confirmation.",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w300),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Your Original Date & Time',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w500),
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
                              controller.state.serviceList.isNotEmpty
                                  ? controller.state.serviceList.first
                                          .data()
                                          .date ??
                                      "date"
                                  : "date",
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              controller.state.serviceList.isNotEmpty
                                  ? controller.state.serviceList.first
                                          .data()
                                          .starttime ??
                                      "time"
                                  : "time",
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Propose Time",
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w500),
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
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _startController,
                                          decoration: const InputDecoration(
                                            hintText: 'Start',
                                            border: InputBorder.none,
                                          ),
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _selectTime(context, _endController),
                              child: AbsorbPointer(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.grey[200],
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _endController,
                                          decoration: const InputDecoration(
                                            hintText: 'End',
                                            border: InputBorder.none,
                                          ),
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.grey[200],
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _totalHours.isEmpty ? 'Total Hours' : _totalHours,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: ApplyButton(
                                onPressed: () {
                                  final String startTime = _startController.text;
                                  final String endTime = _endController.text;
                                  final String totalHours = _totalHours;

                                  // Check if start time is equal to end time
                                  if (startTime == endTime) {
                                    setState(() {
                                      _errorMessage = "Start time and end time cannot be equal";
                                    });
                                    return;
                                  }

                                  // Your logic to change the status to "pending" here

                                  // Call controller method to create propose document
                                  controller.createProposeDocument(startTime, endTime, totalHours);
                                  Get.back();
                                },
                                buttonText: "Continue",
                                buttonWidth: 100,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

