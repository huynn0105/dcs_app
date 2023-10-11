import 'package:dcs_app/utils/enum.dart';

class EnvironmentConfig {
  static String _apiURL = 'https://dev.directivecommunications.com/api/v1';

  static void setEnvironment(Environment env) {
    switch (env) {
      case Environment.dev:
        _apiURL = 'https://dev.directivecommunications.com/api/v1';
        break;
      case Environment.prod:
        _apiURL = 'https://app.directivecommunications.com/api/v1';
        break;
      case Environment.qa:
        _apiURL = 'https://qa.directivecommunications.com/api/v1';
        break;
      case Environment.demo:
        _apiURL = 'https://demo.directivecommunications.com/api/v1';
        break;
      default:
        _apiURL = 'https://dev.directivecommunications.com/api/v1';
        break;
    }
  }

  static String get apiURL => _apiURL;
}
