import 'package:dcs_app/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:dcs_app/presentation/screens/common/custom_button.dart';
import 'package:dcs_app/utils/constants.dart';
import 'package:dcs_app/utils/text_style_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoInternetConnectionScreen extends StatelessWidget {
  const NoInternetConnectionScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0.w),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/dcs_logo.png'),
              SizedBox(height: 20.h),
              Text(
                AppText.noInternet,
                style: TextStyleUtils.bold(15),
              ),
              Text(
                AppText.noInternetMsg,
                style: TextStyleUtils.regular(13),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 26.h),
              CustomButton(
                child: Text(
                  AppText.tryAgain,
                  style:
                      TextStyleUtils.regular(13).copyWith(color: Colors.white),
                ),
                onPressed: () {
                  context.read<AuthBloc>().add(AppLoaded());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
