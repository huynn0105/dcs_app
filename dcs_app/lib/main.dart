import 'package:dcs_app/data/datasources/local/database_manager.dart';
import 'package:dcs_app/presentation/blocs/account_detail_bloc/account_detail_bloc.dart';
import 'package:dcs_app/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:dcs_app/presentation/blocs/create_account_bloc/create_account_bloc.dart';
import 'package:dcs_app/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:dcs_app/presentation/blocs/login_bloc/login_bloc.dart';
import 'package:dcs_app/presentation/blocs/select_account_bloc/select_account_bloc.dart';
import 'package:dcs_app/presentation/screens/home_screen/home_screen.dart';
import 'package:dcs_app/presentation/screens/login_screen/login_screen.dart';
import 'package:dcs_app/presentation/screens/splash_screen/splash_screen.dart';
import 'package:dcs_app/utils/color_utils.dart';
import 'package:dcs_app/global/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/single_child_widget.dart';

import 'global/environment.dart';
import 'presentation/screens/no_internet_connection/no_internet_connection.dart';
import 'global/locator.dart';
import 'utils/enum.dart';

void main() {
  mainDelegate(Environment.prod);
}

Future<void> mainDelegate(Environment env) async {
  WidgetsFlutterBinding.ensureInitialized();
  EnvironmentConfig.setEnvironment(env);
  await initializeDependencies();
  await DatabaseManager.init();
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
        return MultiBlocProvider(
          providers: providers,
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            builder: EasyLoading.init(),
            onGenerateRoute: (settings) => MyRouter.generateRoute(settings),
            home: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
              return switch (state) {
                AuthAuthenticated() => const HomeScreen(),
                AuthNotAuthenticated() || AuthFailure() => const LoginScreen(),
                AuthNoInternetConnection() =>
                  const NoInternetConnectionScreen(),
                AuthInitial() || AuthLoading() => const SplashScreen(),
              };
            }),
            title: 'DCS APP',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: ColorUtils.blue,
                surfaceTint: Colors.transparent,
              ),
              useMaterial3: true,
            ),
          ),
        );
      },
    );
  }

  List<SingleChildWidget> get providers {
    return [
      BlocProvider<HomeBloc>(
        create: (_) => HomeBloc(),
      ),
      BlocProvider<AuthBloc>(
        create: (_) => AuthBloc()..add(AppLoaded()),
      ),
      BlocProvider<LoginBloc>(
        create: (_) => LoginBloc(),
      ),
      BlocProvider<CreateAccountBloc>(
        create: (_) => CreateAccountBloc(),
      ),
      BlocProvider<SelectAccountBloc>(
        create: (_) => SelectAccountBloc(),
      ),
      BlocProvider<AccountDetailBloc>(
        create: (_) => AccountDetailBloc(),
      ),
    ];
  }
}
