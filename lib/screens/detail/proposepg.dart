import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<void> proposeNewPage(BuildContext context) async {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return const ProposeTimeSheet();
    },
  );
}

class ProposeTimeSheet extends StatefulWidget {
  const ProposeTimeSheet({super.key});

  @override
  _ProposeTimeSheetState createState() => _ProposeTimeSheetState();
}

class _ProposeTimeSheetState extends State<ProposeTimeSheet> {
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  String _startPeriod = 'AM';
  String _endPeriod = 'AM';
  String _totalHours = "";

  @override
  void initState() {
    super.initState();
    _startController.addListener(_calculateTotalHours);
    _endController.addListener(_calculateTotalHours);
  }

  void _calculateTotalHours() {
    final String startText = _startController.text;
    final String endText = _endController.text;

    if (startText.isNotEmpty && endText.isNotEmpty) {
      try {
        // Validate time format (12-hour or 24-hour)
        final RegExp timeRegExp =
            RegExp(r'^([0-1][0-9]|2[0-3]):([0-5][0-9])(?: (AM|PM))?$');
        if (!timeRegExp.hasMatch(startText) || !timeRegExp.hasMatch(endText)) {
          throw const FormatException(
              "Invalid time format. Please use HH:MM (24-hour) or HH:MM AM/PM (12-hour).");
        }

        // Parse start and end times based on period presence
        final DateFormat timeFormat =
            _startPeriod.isEmpty ? DateFormat.Hm() : DateFormat.Hm().add_MMM();
        final DateTime startTime = timeFormat.parse("$startText $_startPeriod");
        final DateTime endTime = timeFormat.parse("$endText $_endPeriod");

        // Calculate difference and convert to hours (handling periods)
        int totalHours = endTime.hour - startTime.hour;
        if (_startPeriod != _endPeriod) {
          totalHours += (_endPeriod == 'PM') ? 12 : -12;
        }
        double totalHoursDouble =
            totalHours.toDouble() + (endTime.minute - startTime.minute) / 60.0;

        // Format total hours as HH.MM
        String formattedHours =
            totalHoursDouble.toStringAsFixed(2).replaceAll('.', ':');

        setState(() {
          _totalHours = "$formattedHours hours";
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
    return SafeArea(
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Propose Time",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                const Text(
                  "Once submitted, BuzzBuddy will share your proposed time with the Requester for their confirmation.",
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 5),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Original Date & Time",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(
                      16.0), // Set padding for the container
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(10.0), // Set border radius
                    color: Colors.grey[200], // Set background color
                  ),
                  child: const Text(
                    'Your original date and time here',
                    style: TextStyle(
                      fontSize: 16.0, // Set font size
                      color: Colors.black, // Set text color
                    ),
                  ),
                ),
                const Text(
                  "Propose Time",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: 120, // Adjust the width as needed
                        child: Container(
                          padding: const EdgeInsets.all(
                              16.0), // Set padding for the container
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                10.0), // Set border radius
                            color: Colors.grey[200], // Set background color
                            border: Border.all(
                              // Add border
                              color: Colors.black, // Set border color
                              width: 1.0, // Set border width
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _startController,
                                  decoration: const InputDecoration(
                                    hintText: 'Start', // Placeholder text
                                    border: InputBorder
                                        .none, // Remove default border
                                  ),
                                  keyboardType: TextInputType
                                      .datetime, // Ensure time input
                                  style: const TextStyle(
                                    fontSize: 16.0, // Set font size
                                    color: Colors.black, // Set text color
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              DropdownButton<String>(
                                value: _startPeriod,
                                items: <String>[
                                  'AM',
                                  'PM'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _startPeriod = newValue!;
                                    _calculateTotalHours();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                        width: 10), // Add some spacing between containers
                    Expanded(
                      child: SizedBox(
                        width: 120, // Adjust the width as needed
                        child: Container(
                          padding: const EdgeInsets.all(
                              16.0), // Set padding for the container
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                10.0), // Set border radius
                            color: Colors.grey[200], // Set background color
                            border: Border.all(
                              // Add border
                              color: Colors.black, // Set border color
                              width: 1.0, // Set border width
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _endController,
                                  decoration: const InputDecoration(
                                    hintText: 'End', // Placeholder text
                                    border: InputBorder
                                        .none, // Remove default border
                                  ),
                                  keyboardType: TextInputType
                                      .datetime, // Ensure time input
                                  style: const TextStyle(
                                    fontSize: 16.0, // Set font size
                                    color: Colors.black, // Set text color
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              DropdownButton<String>(
                                value: _endPeriod,
                                items: <String>[
                                  'AM',
                                  'PM'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _endPeriod = newValue!;
                                    _calculateTotalHours();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(
                      16.0), // Set padding for the container
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(10.0), // Set border radius
                    color: Colors.grey[200], // Set background color
                    border: Border.all(
                      // Add border
                      color: Colors.black, // Set border color
                      width: 1.0, // Set border width
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Total Hours: ',
                        style: TextStyle(
                          fontSize: 16.0, // Set font size
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Set text color
                        ),
                      ),
                      Text(
                        _totalHours.isEmpty ? 'Total' : _totalHours,
                        style: const TextStyle(
                          fontSize: 16.0, // Set font size
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Set text color
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
