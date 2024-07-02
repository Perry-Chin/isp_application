import 'package:get/get.dart';

class RouteValidateServiceMiddleware extends GetMiddleware {
  static String? validateServiceName(String? value) {
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

  static String? validateEndTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'End time is required.';
    }
    return null;
  }

  static String? validateImage(String? value) {
    if (value == null || value.isEmpty) {
      return 'Image is required.';
    }
    return null;
  }

  static String? validateTags(String? value) {
    if (value == null || value.isEmpty) {
      return 'At least one tag is required.';
    }

    final tags = value.split(',').map((tag) => tag.trim()).toList();

    if (tags.isEmpty || tags.any((tag) => tag.isEmpty)) {
      return 'Each tag must be a non-empty string.';
    }

    return null;
  }
}
