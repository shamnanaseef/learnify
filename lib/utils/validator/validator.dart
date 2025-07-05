

class AppValidator {

  static String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isNotEmpty && !regex.hasMatch(value)
        ? 'Enter a valid email address'
        : null;
  }



  static String? validatePassword(String? password) {
    // Reset error message

    // Password length greater than 6
    if (password!.length < 8) {
      return 'Password must be longer than 8 characters.\n';
    }

    // Contains at least one uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return '• Uppercase letter is missing.\n';
    }

    // Contains at least one lowercase letter
    if (!password.contains(RegExp(r'[a-z]'))) {
      return '• Lowercase letter is missing.\n';
    }

    // Contains at least one digit
    if (!password.contains(RegExp(r'[0-9]'))) {
      return '• Digit is missing.\n';
    }

    // Contains at least one special character
    if (!password.contains(RegExp(r'[!@#%^&*(),.?":{}|<>]'))) {
      return '• Special character is missing.\n';
    }

    // If there are no error messages, the password is valid
    return null;
  }

  static String? confirmPassValidate(value, String psswd) {
    if (value.isEmpty) {
      return " Confirm your password to continue";
    }

    if (value != psswd) {
      return " Password is not same";
    }
    return null;
  }


}