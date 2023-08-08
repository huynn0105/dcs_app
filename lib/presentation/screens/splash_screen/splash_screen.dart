import 'package:dcs_app/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/images/logo.png',
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 40.h),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: LoadingAnimationWidget.discreteCircle(
                color: ColorUtils.blue,
                size: 40.r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
