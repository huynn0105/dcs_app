import 'package:flutter/material.dart';

abstract class LoginProvider with ChangeNotifier {
  Future<bool> login(String email, String password);
}
