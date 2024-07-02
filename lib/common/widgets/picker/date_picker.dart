// Function to select a data using date picker
import 'package:flutter/material.dart';

import '../../values/values.dart';

Future<void> selectDate(BuildContext context, TextEditingController dateController) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      // Customizing the appearance of the date picker
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

    // If a date is selected, update the dateController text with the selected date
    if (pickedDate != null) {
      dateController.text = pickedDate.toString().split(" ")[0];
    }
  }