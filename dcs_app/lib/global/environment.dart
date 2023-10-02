import 'package:dcs_app/utils/enum.dart';

class EnvironmentConfig {
  static const String _apiURL =
      'https://demo.directivecommunications.com//api/v1';

  static void setEnvironment(Environment env) {
    switch (env) {
      case Environment.dev:
        break;
      case Environment.prod:
        break;
      default:
    }
  }

  static String get apiURL => _apiURL;
}