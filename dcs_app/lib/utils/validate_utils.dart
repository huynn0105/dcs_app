import 'package:dcs_app/utils/constants.dart';

class ValidateUtils {
  static String? isValidEmail(String value) {
    RegExp reg = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (!reg.hasMatch(value)) {
      return AppText.invalidEmailAddress;
    } else {
      return null;
    }
  }
}
