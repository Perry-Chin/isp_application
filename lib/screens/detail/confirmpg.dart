import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<void> proposeNewPage(BuildContext context) async {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20))
    ),
    builder: (BuildContext bc) {
      return const ProposeTimeSheet();
    },
  );
}

class ProposeTimeSheet extends StatefulWidget {
  const ProposeTimeSheet({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProposeTimeSheetState createState() => _ProposeTimeSheetState();
}

class _ProposeTimeSheetState extends State<ProposeTimeSheet> {
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  final String _startPeriod = 'AM';
  final String _endPeriod = 'AM';
  // ignore: unused_field
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
        // Validate time format (HHMM)
        final RegExp timeRegExp = RegExp(r'^([01]?[0-9]|2[0-3])[0-5][0-9]$');
        if (!timeRegExp.hasMatch(startText) || !timeRegExp.hasMatch(endText)) {
          throw const FormatException("Invalid time format. Please use HHMM.");
        }

        // Parse times as DateTime objects
        final DateTime startTime = _parseTime(startText, _startPeriod);
        final DateTime endTime = _parseTime(endText, _endPeriod);

        // Calculate difference and convert to hours
        Duration duration = endTime.difference(startTime);
        if (duration.isNegative) {
          duration += const Duration(hours: 24);
        }
        double totalHoursDouble = duration.inMinutes / 60.0;

        // Format total hours as HH.MM
        String formattedHours = totalHoursDouble.toStringAsFixed(2).replaceAll('.', ':');

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

  DateTime _parseTime(String timeText, String period) {
    final int hour = int.parse(timeText.substring(0, 2));
    final int minute = int.parse(timeText.substring(2, 4));
    return DateFormat('hh:mm a').parse('${hour % 12}:${minute.toString().padLeft(2, '0')} $period');
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
      child: SingleChildScrollView( // Make the content scrollable
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Confirm your booking",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                ),
              ),
              const SizedBox(height: 15,),
              const Text(
                "Once submitted, BuzzBuddy will send a confirmation to both parties for service to be carried out.",
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 15),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Date & Time",
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
                "Total fees",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 10),
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
                child: Column(children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                        Text('Total Payout: '),
                        Text('SGD 40.00'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    const Text('Fee Breakdown', style: TextStyle(color: Colors.blue), ),
                    IconButton(
                      onPressed:() {
                        const Text('Hi');
                      },
                      icon: const Icon(Icons.arrow_drop_down))
                  ],)
                ]),
              ),
              const SizedBox(height: 20),
              
               
            ]
          ),
        ),
      ),
    );
  }
}
