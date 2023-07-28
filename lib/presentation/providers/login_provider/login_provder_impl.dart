import 'package:dcs_app/presentation/providers/login_provider/login_provider.dart';
import 'package:flutter/material.dart';

class LoginProviderImpl with ChangeNotifier implements LoginProvider {
  @override
  Future<bool> login(String email, String password) async {
    if (email.contains('gmail.com')) {
      return true;
    } else {
      return false;
    }
  }
}
