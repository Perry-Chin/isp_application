import 'package:get/get.dart';

class RouteValidateMiddleware extends GetMiddleware {
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Invalid email';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }
    if (!RegExp(r'^[0-9]{8}$').hasMatch(value)) {
      return 'Phone number must have exactly 8 digits';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  static String? validateConfirmPassword(String? confirmvalue, String? oldvalue) {
    if (confirmvalue == null || confirmvalue.isEmpty) {
      return 'Please confirm your password';
    }
    if (confirmvalue != oldvalue) {
      return 'Passwords do not match';
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
}
