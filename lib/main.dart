import 'package:dcs_app/presentation/providers/home_provider/home_provider.dart';
import 'package:dcs_app/presentation/providers/home_provider/home_provider_impl.dart';
import 'package:dcs_app/presentation/providers/login_provider/login_provider.dart';
import 'package:dcs_app/presentation/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'presentation/providers/login_provider/login_provder_impl.dart';

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<HomeProvider>(
                create: (_) => HomeProviderImpl(),
              ),
              ChangeNotifierProvider<LoginProvider>(
                create: (_) => LoginProviderImpl(),
              ),
            ],
            child: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              builder: EasyLoading.init(),
              title: 'DCS APP',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: const LoginScreen(),
            ),
          );
        });
  }
}
