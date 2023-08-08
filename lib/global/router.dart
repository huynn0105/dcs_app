import 'package:dcs_app/presentation/screens/add_account_screen/add_account_screen.dart';
import 'package:dcs_app/presentation/screens/edit_account_screen/edit_account_screen.dart';
import 'package:dcs_app/presentation/screens/select_crg_screen/select_crg_screen.dart';
import 'package:dcs_app/presentation/screens/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';

import '../presentation/screens/home_screen/home_screen.dart';
import '../presentation/screens/login_screen/login_screen.dart';

class MyRouter {
  static const String login = '/login';
  static const String home = '/home';
  static const String addAccount = '/addAccount';
  static const String editAccount = '/editAccount';
  static const String splash = '/splash';
  static const String selectCRG = '/selectCRG';

  static PageRouteBuilder _buildRouteNavigationWithoutEffect(
      RouteSettings settings, Widget widget) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => widget,
      settings: settings,
    );
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return _buildRouteNavigationWithoutEffect(
          settings,
          const LoginScreen(),
        );
      case home:
        return _buildRouteNavigationWithoutEffect(
          settings,
          const HomeScreen(),
        );
      case addAccount:
        return _buildRouteNavigationWithoutEffect(
          settings,
          AddAccountScreen(
            argument: settings.arguments as AddAccountScreenArgument?,
          ),
        );
      case editAccount:
        return _buildRouteNavigationWithoutEffect(
          settings,
          EditAccountScreen(
            argument: settings.arguments as EditAccountScreenArgument,
          ),
        );
      case splash:
        return _buildRouteNavigationWithoutEffect(
          settings,
          const SplashScreen(),
        );
      case selectCRG:
        return _buildRouteNavigationWithoutEffect(
          settings,
          const SelectCRGScreen(),
        );

      default:
        return _buildRouteNavigationWithoutEffect(
          settings,
          Scaffold(
            body: Center(
              child: Text('No route found: ${settings.name}.'),
            ),
          ),
        );
    }
  }

  static void onRouteChanged(String screenName) {
    if (['', null].contains(screenName)) {
      return;
    }
  }
}
