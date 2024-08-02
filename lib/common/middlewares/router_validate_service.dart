import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RouteValidateServiceMiddleware extends GetMiddleware {
  static String? validateService(String? value) {
    if (value == null || value.isEmpty) {
      return 'Service name is required.';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Description is required.';
    }
    return null;
  }

  static String? validateRate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Rate is required.';
    }

    final rateRegExp = RegExp(r'^\d+(\.\d{1,2})?$');

    if (!rateRegExp.hasMatch(value)) {
      return 'Invalid rate format. Please enter a valid number.';
    }

    return null;
  }

  static String? validateLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Location is required.';
    }
    return null;
  }

  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date is required.';
    }
    return null;
  }

  static String? validateStartTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Start time is required.';
    }
    return null;
  }

  static String? validateEndTime(String? startTime, String? endTime) {
    if (endTime == null || endTime.isEmpty) {
      return 'End time is required.';
    }
    if (startTime == endTime) {
      return 'Start time cannot be same as end time';
    }
    final startDateTimeString = '2000-01-01 $startTime';
    final endDateTimeString = '2000-01-01 $endTime';
    final start = DateFormat('yyyy-MM-dd h:mm a').parse(startDateTimeString);
    final end = DateFormat('yyyy-MM-dd h:mm a').parse(endDateTimeString);
    if (start.isAfter(end)) {
      return 'Start time cannot be after end time';
    }
    return null;
  }
}
