class ValidateUtil {
  static String? isValidEmail(String value) {
    RegExp reg = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (!reg.hasMatch(value)) {
      return 'Invalid email address';
    } else {
      return null;
    }
  }
}
