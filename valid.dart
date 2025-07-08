class Validator {
  static String? validateName(String? input) {
  if (input == null || input.isEmpty) {
    return 'Name is required';
  }

  if (!RegExp(r'^[a-zA-Z]').hasMatch(input)) {
    return 'Name must start with a letter';
  }

  if (input.length < 5) {
    return 'Name must be at least 5 characters';
  }

  return null;
}
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$").hasMatch(value)) {
      return 'Enter a valid email';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    return null;
  }

  static String? validateConfirmPassword(
    String? value, String originalPassword) {
    if (value != originalPassword) {
      return 'Passwords do not match';
    }

    return null;
}
}