import 'package:dcs_app/presentation/screens/add_account_screen/add_account_screen.dart';
import 'package:dcs_app/presentation/screens/auto_fill_screen/auto_fill_screen.dart';
import 'package:dcs_app/presentation/screens/edit_account_screen/edit_account_screen.dart';
import 'package:dcs_app/presentation/screens/menu_setting_screen/menu_setting_screen.dart';
import 'package:dcs_app/presentation/screens/select_account_screen/select_account_screen.dart';
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
  static const String selectAccount = '/selectAccount';
  static const String menuSetting = '/menuSetting';
  static const String autoFillSetting = '/autoFillSetting';

  static PageRouteBuilder _buildRouteNavigationWithoutEffect(
      RouteSettings settings, Widget widget) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => widget,
      settings: settings,
    );
  }

  static PageRouteBuilder _buildRouteNavigationWithEffect(
      RouteSettings settings, Widget widget) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => widget,
      settings: settings,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.ease));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
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
            argument: settings.arguments as AddAccountScreenArgument,
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
      case selectAccount:
        return _buildRouteNavigationWithoutEffect(
          settings,
          const SelectAccountScreen(),
        );
      case menuSetting:
        return _buildRouteNavigationWithEffect(
          settings,
          const MenuSettingScreen(),
        );
      case autoFillSetting:
        return _buildRouteNavigationWithEffect(
          settings,
          const AutoFillScreen(),
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
