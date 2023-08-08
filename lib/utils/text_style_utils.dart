import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextStyleUtils {
  static TextStyle bold(int fontSize) => TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: (fontSize + 4).sp,
      );
  static TextStyle medium(int fontSize) => TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: (fontSize + 4).sp,
      );
  static TextStyle regular(int fontSize) => TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: (fontSize + 4).sp,
      );
}
