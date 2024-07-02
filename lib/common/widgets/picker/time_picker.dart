// Function to select a time from the time picker
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../values/values.dart';

Future<void> selectTime(BuildContext context, TextEditingController timeController) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      // Customizing the appearance of the time picker
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            // Customize colors of date picker
            colorScheme: const ColorScheme.light(
              primary: AppColor.secondaryColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColor.secondaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    // If a time is selected, update the timeController text with the selected time
    if (pickedTime != null) {
      timeController.text = pickedTime.format(context);
    }
  }
