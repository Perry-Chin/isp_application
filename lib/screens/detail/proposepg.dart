import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:intl/intl.dart';
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
        final RegExp timeRegExp = RegExp(r'^([01]?[0-9]|2[0-3])[0-5][0-9]$');
        if (!timeRegExp.hasMatch(startText) || !timeRegExp.hasMatch(endText)) {
          throw const FormatException(
              "Invalid time format. Please use HHMM (24-hour) format.");
        }

        final DateTime startTime = _parseTime(startText, _startPeriod);
        final DateTime endTime = _parseTime(endText, _endPeriod);

        Duration duration = endTime.difference(startTime);
        if (duration.isNegative) {
          duration += const Duration(hours: 24);
        }
        double totalHoursDouble = duration.inMinutes / 60.0;

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

  DateTime _parseTime(String timeText, String period) {
    final int hour = int.parse(timeText.substring(0, 2));
    final int minute = int.parse(timeText.substring(2, 4));
    return DateFormat('hh:mm a')
        .parse('${hour % 12}:${minute.toString().padLeft(2, '0')} $period');
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
    return Material(
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
                                        .time ??
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
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
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
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                DropdownButton<String>(
                                  value: _startPeriod,
                                  items: <String>['AM', 'PM']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
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
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
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
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                DropdownButton<String>(
                                  value: _endPeriod,
                                  items: <String>['AM', 'PM']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
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
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
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
                                const Text(
                                  'Total: ',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    _totalHours.isEmpty ? 'Total' : _totalHours,
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
                    const SizedBox(height: 10),
                    Container(
                      width: double.maxFinite,
                      height: 38,
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // Add your onPressed logic here
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              const Color.fromRGBO(44, 68, 138, 1.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13.0),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
