import 'package:dcs_app/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.backgroundColor = ColorUtils.blue,
    this.borderColor,
    this.width,
    this.height,
    this.borderRadius,
    this.elevation = 0,
  }) : super(key: key);
  final Widget child;
  final VoidCallback? onPressed;
  final Color? borderColor;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
        elevation: MaterialStateProperty.all<double>(elevation),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            side: BorderSide(
              color: (borderColor ?? backgroundColor),
            ),
            borderRadius: BorderRadius.circular(
              borderRadius ?? 15.r,
            ),
          ),
        ),
        minimumSize: MaterialStateProperty.all<Size>(
          Size(width ?? 40.w, height ?? 56.h),
        ),
      ),
      child: child,
    );
  }
}
