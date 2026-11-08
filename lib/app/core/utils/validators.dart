import '../constants/app_constants.dart';
import '../constants/app_strings.dart';

/// Pure validation functions.
class Validators {
  Validators._();

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredField;
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredField;
    }
    final RegExp emailRegExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegExp.hasMatch(value.trim())) {
      return AppStrings.invalidEmail;
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.requiredField;
    }
    if (value.length < 8) {
      return AppStrings.passwordMin8;
    }
    return null;
  }

  /// Minimum accepted by the auth provider (Firebase requires 6 characters).
  static String? passwordMin6(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.requiredField;
    }
    if (value.length < AppConstants.minPasswordLength) {
      return AppStrings.passwordMin6;
    }
    return null;
  }

  static String? match(String? value, String? other) {
    if (value == null || value.isEmpty) {
      return AppStrings.requiredField;
    }
    if (value != other) {
      return AppStrings.passwordsDoNotMatch;
    }
    return null;
  }

  static String? nationalId(String? value) {
    if (value == null || !RegExp(r'^\d{9}$').hasMatch(value)) {
      return AppStrings.invalidNationalId;
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredField;
    }
    final String digits = value.trim();
    if (!RegExp(r'^[0-9+\-\s]+$').hasMatch(digits) || digits.replaceAll(RegExp(r'[^0-9]'), '').length < 9) {
      return AppStrings.invalidPhone;
    }
    return null;
  }
}
